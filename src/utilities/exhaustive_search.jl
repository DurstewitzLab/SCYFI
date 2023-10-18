


""" 
calculate the cycles for a specified PLRNN with parameters A,W,h up until order k
"""
function main_exhaustive(
    A:: Array, W:: Array, h:: Array, order:: Integer;
     )
    found_lower_orders = Array[]
    found_eigvals = Array[]
    idx_arr = Array[]
    t = Array[]

    for i =1:order
        start_t = time()
        cycles_found, eigvals, idx = exhaustive_search(A, W, h, i, found_lower_orders)
        end_t = time()

        push!(found_lower_orders,cycles_found)
        push!(found_eigvals,eigvals)
        push!(idx_arr,idx)
        push!(t,[end_t-start_t])
    end
    return [found_lower_orders, found_eigvals,idx_arr, t]
end


function exhaustive_search(A:: Array, W:: Array, h:: Array, order:: Integer, found_lower_orders:: Array)
    dim=size(A)[1]
    n = 2^dim
    cycles_found = Array[]
    eigvals =  Array[]
    idx_found = Array[]

    iter = Iterators.product([0:(n-1) for j=1:order]...)
    for (idx, item) in enumerate(iter)
        relu_matrix_list = construct_relu_matrix_list_exhaustive(dim,order,item)
        z_candidate = get_cycle_point_candidate(A, W, relu_matrix_list, h, order)
        difference_relu_matrices = 1
        if z_candidate !== nothing
            trajectory = get_latent_time_series(order, A, W, h, dim, z_0=z_candidate)
            trajectory_relu_matrix_list = Array{Bool}(undef, dim, dim, order)
            for j = 1:order
                trajectory_relu_matrix_list[:,:,j] = Diagonal(trajectory[j].>0)
            end
            for j = 1:order
                difference_relu_matrices = sum(abs.(trajectory_relu_matrix_list[:,:,j].-relu_matrix_list[:,:,j]))
                if difference_relu_matrices != 0
                    break
                end
                if !isempty(found_lower_orders)
                    if map(temp -> round.(temp, digits=2), trajectory[1]) ∈ map(temp -> round.(temp,digits=2),collect(Iterators.flatten(Iterators.flatten(found_lower_orders))))
                        difference_relu_matrices = 1
                        break
                    end
                end
            end
            if difference_relu_matrices == 0
                if map(temp1 -> round.(temp1, digits=2), trajectory[1]) ∉ map(temp -> round.(temp, digits=2), collect(Iterators.flatten(cycles_found)))
                    e = get_eigvals(A,W,relu_matrix_list,order)
                    push!(cycles_found,trajectory)
                    push!(eigvals,e)
                    push!(idx_found,[idx])
                    i=0
                    c=0
                end
            end
        end
        #println(relu_matrix_list,z_candidate)
    end
   return cycles_found, eigvals,idx_found
end


"""
Construct a list of relu matrices for a random sequence of quadrants
"""
function construct_relu_matrix_list_exhaustive(dim::Integer, order::Integer,n::Tuple)
    relu_matrix_list = Array{Bool}(undef, dim, dim, order)
    for i = eachindex(n)
        relu_matrix_list[:,:,i] = construct_relu_matrix(Int128(n[i]), dim)
    end
    return relu_matrix_list,n[1]
end


function test_exhaustive_search(A,W,h,order)
    A = [[0.4688040021749482 0.0]; [0.0 -0.6124266402970175]]#; [0.0 -0.6124266402970175]]
    W = [[0.0 1.7253921307363493]; [-0.22529820688589786 0.0]]#; [0.0 -0.6124266402970175]]
    h = [[1.6024054836526365]; [0.6123993108987379]]#; [0.6123993108987379]]

    @time res_ex=main_exhaustive(A,W,h,order)
    @time res_scyfi = main(A,W,h,order)
    @assert res_scyfi[1] ==res_ex[1]
    @assert res_scyfi[2] ==res_ex[2]
    
    println("if you get here; everything is fine")
    println(res_scyfi)
    println(res_ex)
end

"""
Gat the unique number of a linear region 
"""
function get_unique_number_linear_regions(dim,order,trajectory_relu_matrix)
    oom = floor(Int,log10(2^dim))
    n_list = Array{Int}(undef,order)
    for i = 1:order
        n_list[i] = parse(Int,join(string.(Int.((diag(trajectory_relu_matrix[:,:,i]))))),base=2)
    end
    unique_number = join(n_list)
    return parse(Float64,unique_number)
end