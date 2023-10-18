include("scyfi_algo.jl")

""" 
calculate the cycles for a specified PLRNN with parameters A,W,h up until order k
"""
function find_cycles(
    A:: Array, W:: Array, h:: Array, order:: Integer;
    outer_loop_iterations:: Union{Integer,Nothing}= nothing,
    inner_loop_iterations:: Union{Integer,Nothing} = nothing
     )
    found_lower_orders = Array[]
    found_eigvals = Array[]
     
    for i =1:order
        cycles_found, eigvals = scy_fi(A, W, h, i, found_lower_orders, outer_loop_iterations=outer_loop_iterations,inner_loop_iterations=inner_loop_iterations)
     
        push!(found_lower_orders,cycles_found)
        push!(found_eigvals,eigvals)
    end
    return [found_lower_orders, found_eigvals]
end

""" 
calculate the cycles for a specified shPLRNN up until order k
shPLRNN
"""
function find_cycles(
    A::AbstractVector,
    W₁::AbstractMatrix,
    W₂::AbstractMatrix,
    h₁::AbstractVector,
    h₂::AbstractVector,
    order:: Integer;
    outer_loop_iterations:: Union{Integer,Nothing} = nothing,
    inner_loop_iterations:: Union{Integer,Nothing} = nothing
    )
    found_lower_orders = Array[]
    found_eigvals = Array[]
     
    for i =1:order
        cycles_found, eigvals = scy_fi(A, W₁, W₂, h₁, h₂, i, found_lower_orders, outer_loop_iterations=outer_loop_iterations,inner_loop_iterations=inner_loop_iterations)
     
        push!(found_lower_orders,cycles_found)
        push!(found_eigvals,eigvals)
    end
    return [found_lower_orders, found_eigvals]
end
