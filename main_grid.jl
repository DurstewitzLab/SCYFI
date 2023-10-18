using SCYFI
using Base.Threads
using ProgressMeter
using CSV
using JLD2

#using Pandas

""" 
calculate the cycles for a 2D PLRNN on a 2D parameter grid up until order k
"""
function main_grid(
    A::Array,
    W::Array,
    h::Array,
    order::Integer,
    param_changed_1::String,
    param_changed_2::String,
    param_1::Array,
    param_2::Array;
    filepath::String ="result/system_001_res_new.pkl",
    filepath_img::String="result/system_001_res_new"
    )
    #hdf5()
    println("starting calculation")
    println("Using ", Threads.nthreads()," threats")
    data_list =  create_grid_data(A,W,h,param_changed_1,param_changed_2,param_1,param_2)
    result = fill([],length(data_list)) 
    p = Progress(length(data_list))
    Threads.@threads for i in eachindex(data_list)
        result[i] = find_cycles(data_list[i][1],data_list[i][2],data_list[i][3],order,inner_loop_iterations=30,outer_loop_iterations=100)#,inner_loop_iterations=550,outer_loop_iterations=100)
        next!(p)
    end
    @time begin
        df = convert_data_to_dataframe(A,W,h,result,order,param_1,param_2)
    end
   # CSV.write(filepath, df)
    println("starting plotting")
    h = find_bifurcations_parameter_grid(df)
    display(h)
    show(h)
    save(filepath_img * ".jld2","data",df)
    #Plots.hdf5plot_write(h, filepath_img * ".hdf5")
    #savefig(filepath_img * ".png")
    

    return df
end

# example snippet:
a11 = 0.
a22 = 0.2
a21 = -0.4
a12 = 0.8
w12 = 0.
w21 = 0.9
w11 = -2.
w22 = 0.
h1 = 0.214
h2 = 0.

a11 = 0.83777
a22 = 0.96461
a21 = 0
a12 = 0
w12 = -0.64375
w21 = 0.52505
w11 = 0.
w22 = 0.
h1 = 0.37298
h2 = -0.97931

A = [[a11 a12]; [a21 a22]]
W = [[w11 w12]; [w21 w22]]
h = [[h1]; [h2]]

res=main_grid(A,W,h,1,"a11","a22",[-1:0.01:1;],[-1:0.01:1;],filepath_img="new")
println(res)