using LinearAlgebra
using Random
using Printf
#using Pandas
using DataFrames
using Plots
using ProgressMeter
using LaTeXStrings

"""
Prepeare the data on a 2D parameter grid
"""
function create_grid_data(
    A::Array,
    W::Array,
    h::Array,
    param_changed_1::String,
    param_changed_2::String,
    param_1::Array,
    param_2::Array
    )
    data_list = Array[]
    for i = 1:length(param_1)
        for j = 1:length(param_2)
            A₁ = A
            W₁ = W
            h₁ = h
            if param_changed_1 == "a11"
                A₁ = A₁ + [[param_1[i] 0]; [0 0]]
            elseif param_changed_1 == "a12"
                A₁ = A₁ + [[0 param_1[i]]; [0 0]]
            elseif param_changed_1 == "a21"
                A₁ = A₁ + [[0 0]; [param_1[i] 0]]
            elseif param_changed_1 == "a22"
                A₁ = A₁ + [[0 0]; [0 param_1[i]]]
            elseif param_changed_1 == "w12"
                W₁ = W₁ + [[0 param_1[i]]; [0 0]]
            elseif param_changed_1 == "w21"
                W₁ = W₁ + [[0 0]; [param_1[i] 0]]
            elseif param_changed_1 == "w11"
                W₁ = W₁ + [[param_1[i] 0]; [0 0]]
            elseif param_changed_1 == "w22"
                W₁ = W₁ + [[0 0]; [0 param_1[i]]]
            elseif param_changed_1 == "h1"
                h₁ = h₁ + [[param_1[i]]; [0]]
            elseif param_changed_1 == "h2"
                h₁ = h₁ + [[0]; [param_1[i]]]
            else
                @printf("%s not a valid parameter string, should be 'a1' for example",param_changed_1)
            end

            if param_changed_2 == "a11"
                A₁ = A₁ + [[param_2[j] 0]; [0 0]]
            elseif param_changed_2 == "a12"
                A₁ = A₁ + [[0 param_2[j]]; [0 0]]
            elseif param_changed_2 == "a21"
                A₁ = A₁ + [[0 0]; [param_2[j] 0]]
            elseif param_changed_2 == "a22"
                A₁ = A₁ + [[0 0]; [0 param_2[j]]]
            elseif param_changed_2 == "w12"
                W₁ = W₁ + [[0 param_2[j]]; [0 0]]
            elseif param_changed_2 == "w21"
                W₁ = W₁ + [[0 0]; [param_2[j] 0]]
            elseif param_changed_2 == "w11"
                W₁ = W₁ + [[-param_1[i]+param_2[j] 0]; [0 0]]
            elseif param_changed_2 == "w22"
                W₁ = W₁ + [[0 0]; [0 param_2[j]]]
            elseif param_changed_2 == "h1"
                h₁ = h₁ + [[param_2[j]]; [0]]
            elseif param_changed_2 == "h2"
                h₁ = h₁ + [[0]; [param_2[j]]]
            else
                @printf("%s not a valid parameter string, should be 'a1' for example",param_changed_2)
            end
            push!(data_list,[A₁,W₁,h₁])
        end
    end
    return data_list
end


"""
Convert the data from main_grid in a dataframe with pandas 
"""
function convert_data_to_dataframe_python(A::Matrix, W:: Matrix, h:: Vector, data::Array, order::Integer, param_1::Vector, param_2::Vector)
    df = Pandas.DataFrame(columns=["grid_coordinates" , "cycle_order_k" , "number_of_cycles_found" , "cycles", "eigvals" , "A","W", "h"])
    df=df.pyo
    for n =1:order 
        counter = 1
        #for i in eachindex(data)s
        for i in eachindex(param_1)
            for j in eachindex(param_2)
                if counter <= length(data)
                    df_temp = Pandas.DataFrame(Dict(:"grid_coordinates" =>[[param_1[i], param_2[j]]], :"cycle_order_k"=>[n], :"number_of_cycles_found"=>[length(data[counter][1][n])], :"cycles"=>[data[counter][1][n]], :"eigvals"=>[data[counter][2][n]],:"A"=>[A],:"W"=>[W],:"h"=>[h]))
                    df=df[:append](df_temp, ignore_index = true)
                    counter += 1
                end
            end
        end
    end
    return df
end

"""
Convert the data from main_grid in a dataframe
"""
function convert_data_to_dataframe(A::Matrix, W:: Matrix, h:: Vector, data::Array, order::Integer, param_1::Vector, param_2::Vector)
    df = DataFrame(grid_coordinates = Tuple[], number_of_cycles_found = Int[], cycles=Array[], eigvals = Array[], A=Array[],W=Array[], h=Array[])

    #for n =1:order 
    counter = 1
    for i in eachindex(param_1)
        for j in eachindex(param_2)
            if counter <= length(data)
                push!(df, ((param_1[i],param_2[j]), length(data[counter][1]),data[counter][1],data[counter][2],A,W,h))
                counter += 1
            end
        end
    end
    #end
    return df
end


"""
Find the bifurcations on a 2D parameter grid
"""
function find_bifurcations_parameter_grid(df::DataFrame)
    # go through every row and draw a line between grid points if either number or stability of 
    # objects changes
    grid_length = Integer(sqrt(size(df,1)))
    dy = abs(df[1+grid_length,"grid_coordinates"][1]-df[1,"grid_coordinates"][1])
    dx = abs(df[2,"grid_coordinates"][2]-df[1,"grid_coordinates"][2])

    ddx = dx/10
    ddy = dy/10
    P=plot(size=(1000,600),xtickfont=font(25), legend = false,  font_family="sans-serif", ytickfont=font(25),xguidefontsize=32,yguidefontsize=32,legendfont=font(26),margin=7Plots.mm)
    prog = Progress(nrow(df))
    for i = 1:nrow(df)
        #println(i)
        #display(P)
        if mod(i,grid_length)!=0
            if length.(df[i,"cycles"])!=length.(df[i+1,"cycles"])
                plot!(P,df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2,ones(length(df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2))*(df[i,"grid_coordinates"][2]+dx/2),legend=false,color="black",linewidth=3)
            else
                for n in eachindex(df[1,"cycles"])
                    same_stability_indices_found = []
                    for j in eachindex(df[i,"cycles"][n])
                        same_stability_indices = compare_stability(df[i,"eigvals"][n][j],df[i+1,"eigvals"][n])
                        # no match in stability means a bifurcation occured
                        if same_stability_indices === nothing
                            plot!(P,df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2,ones(length(df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2))*(df[i,"grid_coordinates"][2]+dx/2),legend=false,color="red",linewidth=3)
                            break
                        else
                            # if the cycle with same stability is also closest in state space -> no bifurcation
                            if length(same_stability_indices) == 1
                                #distance_cycles = get_minimal_state_space_distances(df[i,"cycles"][n][j],df[i+1,"cycles"][n])
                                #index_min = argmin(distance_cycles)
                                #if index_min != same_stability_indices[1] || same_stability_indices[1] in same_stability_indices_found
                                if same_stability_indices[1] in same_stability_indices_found
                                    plot!(P,df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2,ones(length(df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2))*(df[i,"grid_coordinates"][2]+dx/2),legend=false,color="red",linewidth=3)
                                else
                                    append!(same_stability_indices_found, same_stability_indices)
                                end
                            else
                                distance_cycles = get_combined_state_space_eigenvalue_distance(df[i,"cycles"][n][j],df[i+1,"cycles"][n], df[i,"eigvals"][n][j],df[i+1,"eigvals"][n])
                                index_min = argmin(distance_cycles)
                                if index_min in same_stability_indices_found
                                    plot!(P,df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2,ones(length(df[i,"grid_coordinates"][1]-dy/2:ddy:df[i,"grid_coordinates"][1]+dy/2))*(df[i,"grid_coordinates"][2]+dx/2),legend=false,color="red",linewidth=3)
                                else
                                    append!(same_stability_indices_found, index_min)
                                end
                            end
                        end
                    end
                end
            end
        end
        if i < size(df,1)-grid_length
            if length.(df[i,"cycles"])!=length.(df[i+grid_length,"cycles"])
                plot!(P,ones(length(df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2))*(df[i,"grid_coordinates"][1]+dy/2),df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2,legend=false,color="black",linewidth=3)
            else
                for n in eachindex(df[1,"cycles"])
                    same_stability_indices_found = []
                    for j in eachindex(df[i,"cycles"][n])
                        same_stability_indices = compare_stability(df[i,"eigvals"][n][j],df[i+grid_length,"eigvals"][n])
                        # no match in stability means a bifurcation occured
                        if same_stability_indices === nothing
                            plot!(P,ones(length(df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2))*(df[i,"grid_coordinates"][1]+dy/2),df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2,legend=false,color="red",linewidth=3)
                            break
                        else
                            # if the cycle with same stability is also closest in state space -> no bifurcation
                            if length(same_stability_indices) == 1
                                #distance_cycles = get_minimal_state_space_distances(df[i,"cycles"][n][j],df[i+grid_length,"cycles"][n])
                               # index_min = argmin(distance_cycles)
                                #if index_min != same_stability_indices[1] || same_stability_indices[1] in same_stability_indices_found
                                if same_stability_indices[1] in same_stability_indices_found
                                    plot!(P,ones(length(df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2))*(df[i,"grid_coordinates"][1]+dy/2),df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2,legend=false,color="red",linewidth=3)
                                else
                                    append!(same_stability_indices_found, same_stability_indices)
                                end
                            else
                                distance_cycles = get_combined_state_space_eigenvalue_distance(df[i,"cycles"][n][j],df[i+grid_length,"cycles"][n], df[i,"eigvals"][n][j],df[i+grid_length,"eigvals"][n])
                                index_min = argmin(distance_cycles)
                                if index_min in same_stability_indices_found
                                    plot!(P,ones(length(df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2))*(df[i,"grid_coordinates"][1]+dy/2),df[i,"grid_coordinates"][2]-dx/2:ddx:df[i,"grid_coordinates"][2]+dx/2,legend=false,color="red",linewidth=3)
                                else
                                    append!(same_stability_indices_found, index_min)
                                end
                            end
                        end
                    end 
                end
            end
        end
        next!(prog)
    end
    xlabel!(L"a_l")
    ylabel!(L"a_r")
    return P
end

"""
Compare the stability of one cycle to all neighbouring cycles
Here we only compare the total number of stable and unstable directions and compare them to one another
"""
function compare_stability(eigvals::Array, eigvals_neighbour::Array)
    same_stability_index = []
    #eigvals as [x,x]
    norm_1 = abs.(eigvals).<1
    number_stable_dimensions_1 = sum(norm_1)
    for i in eachindex(eigvals_neighbour)
        norm_2 = abs.(eigvals_neighbour[i]).<1
        number_stable_dimensions_2 = sum(norm_2)
        if number_stable_dimensions_1==number_stable_dimensions_2
            append!(same_stability_index,i)
        end
    end
    if same_stability_index==[]
        return nothing
    end
    return same_stability_index
end

"""
Compare one cycle to all neighboring cycles and return the sum of the minimal euclidean distance between them in state space and the distance in eigenvalues
"""
function get_combined_state_space_eigenvalue_distance(cycle::Array, cycles_neighbour::Array,eigenvalue::Array, eigenvalue_neighbour::Array)
    distance_cycles = get_minimal_state_space_distances(cycle, cycles_neighbour)
    distance_eigvals = get_minimal_eigenvalue_distances(eigenvalue, eigenvalue_neighbour)
    return distance_cycles .+ distance_eigvals
end

"""
Compare one cycle to all neighboring cycles and return  minimal distance between them in state space
"""
function get_minimal_state_space_distances(cycle::Array, cycles_neighbour::Array)
    distance_list = []
    for i in eachindex(cycles_neighbour)
        distance = Inf   
        for j in eachindex(cycles_neighbour[i])
            mean_distance = norm(cycle - circshift(cycles_neighbour[i],j))
            if mean_distance < distance
                distance = mean_distance
            end
        end
        append!(distance_list,distance)
    end
    return distance_list
end

"""
Compare one cycles eigenvalues to all neighboring cycles eigenvalues and return  minimal distance between them
"""
function get_minimal_eigenvalue_distances(eigenvalue::Array, eigenvalue_neighbour::Array)
    distance_list = []
    for i in eachindex(eigenvalue_neighbour)
        distance = Inf   
        for j in eachindex(eigenvalue_neighbour[i])
            mean_distance = norm(eigenvalue - circshift(eigenvalue_neighbour[i],j))
            if mean_distance < distance
                distance = mean_distance
            end
        end
        append!(distance_list,distance)
    end
    return distance_list
end


"""
Find the bifurcations along a trainingstrajectory
"""
function find_bifurcations_trajectory(df::DataFrame, model_numbers::StepRange)
    # go through the trajectory and find bifurcation if either number or stability of 
    # objects changes
    epochs=[]
    orers=[]
    for i = 1:nrow(df)-1
        if length.(df[i,"cycles"])!=length.(df[i+1,"cycles"])
            println("Number of detected cycles changes between"*string(model_numbers[i])*"and"*string(model_numbers[i+1]))
            println("The number of found cycles are:")
            println("model"*string(model_numbers[i])*":")
            println(length.(df[i,"cycles"]))
            println("model"*string(model_numbers[i+1])*":")
            println(length.(df[i+1,"cycles"]))
            append!(epochs,string(model_numbers[i]))
        end
        for n in eachindex(df[1,"cycles"])
            same_stability_indices_found = []
            for j in eachindex(df[i,"cycles"][n])
                same_stability_indices = compare_stability(df[i,"eigvals"][n][j],df[i+1,"eigvals"][n])
                # no match in stability means a bifurcation occured
                if same_stability_indices === nothing
                    println("Stability of detected cycles changes between model "*string(model_numbers[i])*" and model "*string(model_numbers[i+1])*" in order"*string(n))
                    append!(epochs,string(model_numbers[i]))
                    break
                else
                    # if the cycle with same stability is also closest in state space -> no bifurcation
                    if length(same_stability_indices) == 1
                        #distance_cycles = get_minimal_state_space_distances(df[i,"cycles"][n][j],df[i+1,"cycles"][n])
                        #index_min = argmin(distance_cycles)
                        #if index_min != same_stability_indices[1] || same_stability_indices[1] in same_stability_indices_found
                        if same_stability_indices[1] in same_stability_indices_found
                            println("Stability of detected cycles changes between model "*string(model_numbers[i])*" and model "*string(model_numbers[i+1])*" in order"*string(n))
                            append!(epochs,string(model_numbers[i]))
                        else
                            append!(same_stability_indices_found, same_stability_indices)
                        end
                    else
                        distance_cycles = get_combined_state_space_eigenvalue_distance(df[i,"cycles"][n][j],df[i+1,"cycles"][n], df[i,"eigvals"][n][j],df[i+1,"eigvals"][n])
                        index_min = argmin(distance_cycles)
                        if index_min in same_stability_indices_found
                            println("Stability of detected cycles changes between model "*string(model_numbers[i])*" and model "*string(model_numbers[i+1])*" in order"*string(n))
                            append!(epochs,string(model_numbers[i]))
                        else
                            append!(same_stability_indices_found, index_min)
                        end
                    end
                end
            end
        end
    end
    return epochs
end
