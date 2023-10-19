using SCYFI
using Base.Threads
using ProgressMeter
using CSV
using Base.Threads
using JLD2: save

"""
This package contains the code from [Eisenmann L., Monfared M., Göring N., Durstewitz D. Bifurcations and loss jumps in RNN training, Thirty-seventh Conference on Neural Information Processing Systems, 2023,
{https://openreview.net/forum?id=QmPf29EHyI}]. Please cite this work when using the code provided herewith
"""

""" 
calculate the cycles along a trajectory up until order k, for anything higher dmensional than 2d the standard hyperparameters for the loops will not be large enough and have to be tuned again
"""
function main_trajectory(
    experiment_path:: String,
    order::Integer;
    start::Integer=1,
    stop::Integer=Integer(length(data["Loss"])),
    step::Integer=1,
    outer_loop_iterations:: Union{Integer,Nothing}= nothing,
    inner_loop_iterations:: Union{Integer,Nothing} = nothing
    )
    println("loading function worked")
    data=load(experiment_path)
    model_numbers = start:step:stop
    result = fill([],length(model_numbers)) 
    df = DataFrame(number_of_cycles_found = Int[], cycles=Array[], eigvals = Array[], A=Array[],W=Array[], h=Array[])

    p = Progress(length(model_numbers))
    println("starting calculation")
    println("Using ", Threads.nthreads()," threats")
    Threads.@threads for i in eachindex(model_numbers)
        val=model_numbers[i]
        result[i] = find_cycles(diagm(data["A"][val]),data["W"][val],data["h"][val],order, outer_loop_iterations= outer_loop_iterations,inner_loop_iterations=inner_loop_iterations)  
        next!(p)
    end

    println("generate dataframe")
    for (i,val) in enumerate(model_numbers)    
        push!(df, ((length(result[i][1]),result[i][1],result[i][2],data["A"][val],data["W"][val],data["h"][val])))      
    end
    epochs = find_bifurcations_trajectory(df, model_numbers)
    save(experiment_path*"dynamical_objects2.jld2","dynamical_objects",result)
    CSV.write(experiment_path*"dynamical_objects.csv", df)  
    return epochs
end

#main_trajectory(
#    "result/BS15/test/001/checkpoints",
#    10,
#    30,
#    10,
#    15,
#    outer_loop_iterations=100,
#    inner_loop_iterations=1000
 #   )
