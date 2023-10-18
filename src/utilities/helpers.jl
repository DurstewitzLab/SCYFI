using LinearAlgebra
using Random
using Distributions

"""
Matrix describing the Relu function for different quadrants(subcompartments)
"""
function construct_relu_matrix(number_quadrant::Int128, dim::Integer)
    quadrant_index = bitstring(number_quadrant)
    return Diagonal(convert(Array{Bool},collect(reverse(quadrant_index[length(quadrant_index)-dim+1:end])).=='1'))
end

"""
Construct a list of relu matrices for a random sequence of quadrants
"""
function construct_relu_matrix_list(dim::Int, order::Integer)
    relu_matrix_list = Array{Bool}(undef, dim, dim, order)
    for i = 1:order
        n = floor(rand(1)[1]*2^dim)
        relu_matrix_list[:,:,i] = construct_relu_matrix(Int128(n), dim)
    end
    return relu_matrix_list
end

"""
Construct a list of relu matrices for a random sequence of quadrants drawn from the allowed D's of the pool
shPLRNN
"""
function construct_relu_matrix_list(relu_pool:: Array, order::Integer)
    return relu_pool[:,:,rand(1:size(relu_pool)[3],order)]   
end


"""
Initialise pool of admissable Relu matrices for the shallow PLRNN
"""
function construct_relu_matrix_pool(A:: Array, W1:: Array, W2:: Array, h1::Array, h2::Array,dim::Integer, hidden_dim::Integer)
    # credit @Niclas Goering
    n_points=10000000
    corr=Matrix{Int64}(undef,n_points,hidden_dim)
    #init array D_List to store all D in
    m =rand(Uniform(-10,10),dim, n_points)
    for j in 1:size(corr,1)
        corr[j,:]=Bool.((W2 * m[:,j] .+ h2) .>0)
    end
    un=unique(corr,dims=1)
    D_list=Array{Bool}(undef, hidden_dim, hidden_dim, size(un,1))
    for k = 1:size(un,1)
        D=Diagonal(Bool.(un[k,:]))
        D_list[:,:,k] = D
    end
    return D_list
end



"""
# Construct a list of relu matrices for a random sequence of quadrants faster version
# """
# function construct_relu_matrix_list(dim::Integer, order::Integer)
#     return [bitrand(dim) for _ ∈ 1:order]
# end

"""
get the candidate for a cycle point by solving the cycle equation:
(A+WD_k)*...*(A+WD_1) *z + [(A+WD_k)*...*(A+WD_2)+...+(A+WD)**1+1]*h = z
"""
function get_cycle_point_candidate(A:: Array, W:: Array, D_list:: Array, h::Array, order::Integer)
    z_factor = get_factor_in_front_of_z(A, W, D_list, order)
    z_candidate = nothing
    try
        inverse_matrix = inv(I-z_factor)
        #println(I-z_factor)
        h_factor = get_factor_in_front_of_h(A, W, D_list[:,:,2:end], order)
        z_candidate = inverse_matrix *(h_factor*h)
    catch
        #println("Matrix is not invertible", "A",A,"W",W)
    end
    return z_candidate #, z_factor
end


"""
get the candidate for a cycle point by solving the cycle equation
shPLRNN
"""
function get_cycle_point_candidate( A::AbstractVector,
    W₁::AbstractMatrix,
    W₂::AbstractMatrix,
    h₁::AbstractVector,
    h₂::AbstractVector,
    D_list:: Array,
    order::Integer)

    z_factor, h₁_factor, h₂_factor = get_factors(A, W₁, W₂, D_list, order)
    z_candidate = nothing
    try
        inverse_matrix = inv(I-z_factor)
        z_candidate = inverse_matrix *(h₁_factor*h₁ + h₂_factor*h₂)
    catch
        #Not invertible?
    end
    return z_candidate #, z_factor
end


"""
recursively applying map gives us: (A+WD_k)*...*(A+WD_1) *z + [(A+WD_k)*...*(A+WD_2)+...+(A+WD)**1+1]*h = z
Here we want to calculate the factor in front of z recursively
"""
function get_factor_in_front_of_z(A:: Array, W:: Array, D_list:: Array, order::Integer)
    factor = I
    for i = 1:order
        factor = (A+ W*D_list[:,:,i])* factor
    end
    return factor
end

"""
recursively applying map gives us: (A+WD_k)*...*(A+WD_1) *z + [(A+WD_k)*...*(A+WD_2)+...+(A+WD)**1+1]*h = z
Here we want to calculate the factor in front of h recursively.
"""
function get_factor_in_front_of_h(A:: Array, W:: Array, D_list:: Array, order::Integer)
    factor = I
    for i = 1:order-1
        factor = (A+ W*D_list[:,:,i]) * factor + I
    end
    return factor
end

"""
Here we want to calculate the factors in front of z/h_1/h_2 recursively
shPLRNN
"""
function get_factors(A::AbstractVector, W₁::AbstractMatrix, W₂::AbstractMatrix, D_list::Array, order::Integer)
    hidden_dim = size(W₂)[1]
    latent_dim = size(W₁)[1]
    factor_z = I#Matrix(I,latent_dim,latent_dim)
    factor_h₁ = I#Matrix(I,latent_dim,latent_dim)
    factor_h₂ = W₁*D_list[:,:,1]*I#*Matrix(I,hidden_dim, hidden_dim)
    for i = 1:order-1
        factor_z = (Diagonal(A) + (W₁*D_list[:,:,i])*W₂)*factor_z
        factor_h₁ = (Diagonal(A) + (W₁*D_list[:,:,i+1])*W₂)*factor_h₁ + I
        factor_h₂ = (Diagonal(A) + (W₁*D_list[:,:,i+1])*W₂)*factor_h₂ + (W₁*D_list[:,:,i+1])
    end
    factor_z = (Diagonal(A) + (W₁*D_list[:,:,order])*W₂)*factor_z
    return factor_z, factor_h₁, factor_h₂
end


"""
Generate the time series by iteravely applying the PLRNN
"""
function get_latent_time_series(time_steps:: Integer, A:: Array, W:: Array, h:: Array, dz::Integer; z_0:: Array= nothing)
    if z_0 === nothing
        z = transpose(randn(1,dz))
    else
        z = z_0
    end
    trajectory = Array{Array}(undef, time_steps)
    trajectory[1] = z
    for t = 2:time_steps
        z = latent_step(z, A, W, h)
        trajectory[t] = z
    end
    return trajectory
end

"""
Generate the time series by iteravely applying the shPLRNN
shPLRNN
"""
function get_latent_time_series(time_steps:: Integer,     
    A::AbstractVector,
    W₁::AbstractMatrix,
    W₂::AbstractMatrix,
    h₁::AbstractVector,
    h₂::AbstractVector,
    dz::Integer;
    z_0:: Array= nothing)
    if z_0 === nothing
        z = transpose(randn(1,dz))
    else
        z = z_0
    end
    trajectory = Array{Array}(undef, time_steps)
    trajectory[1] = z
    for t = 2:time_steps
        z = latent_step(z, A, W₁, W₂, h₁, h₂)
        trajectory[t] = z
    end
    return trajectory
end


"""
PLRNN step
"""
function latent_step(z:: Array, A:: Array, W:: Array, h::Array)
    return A*z + W*max.(0,z) + h
end

"""
shPLRNN step
"""
function  latent_step(
    z::AbstractArray,
    A::AbstractVector,
    W₁::AbstractMatrix,
    W₂::AbstractMatrix,
    h₁::AbstractVector,
    h₂::AbstractVector,)
    return A .* z .+ W₁ * max.(W₂ * z .+ h₂,0) .+ h₁
end


"""
Set the hyperparameters to predefined values if no value given (tuned for 2D case)
"""
function set_loop_iterations(order:: Integer, outer_loop:: Union{Integer,Nothing}, inner_loop:: Union{Integer,Nothing})
    if outer_loop === nothing
        if order < 8 outer_loop=10 elseif order < 30 outer_loop=40 else outer_loop=100 end
    end
    if inner_loop === nothing
        if order < 3 inner_loop=20 elseif order < 6 inner_loop=60 elseif order < 8 inner_loop=300 elseif order < 20 inner_loop=1080 else inner_loop=1115 end
    end
    return outer_loop, inner_loop
end

"""
Get the eigenvalues for all the points along the trajectory to learn about the stability
"""
function get_eigvals(A:: Array, W:: Array, D_list:: Array, order::Integer)
    e = I
    for i = 1:order
        e = (A + W * D_list[:,:,i]) * e
    end
    return eigvals(e) 
end


"""
Get the eigenvalues for all the points along the trajectory to learn about the stability
shPLRNN
"""
function get_eigvals( A::AbstractVector,
    W₁::AbstractMatrix,
    W₂::AbstractMatrix, 
    D_list:: Array, 
    order::Integer)
    e = I
    for i = 1:order
        e = (Diagonal(A) + (W₁ * D_list[:,:,i] * W₂)) * e
    end
    return eigvals(e) 
end
