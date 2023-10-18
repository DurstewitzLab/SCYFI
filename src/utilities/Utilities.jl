module Utilities
export construct_relu_matrix,
    construct_relu_matrix_list,
    construct_relu_matrix_pool,
    get_cycle_point_candidate,
    get_factor_in_front_of_z,
    get_factor_in_front_of_h,
    get_factors,
    get_latent_time_series,
    latent_step,
    set_loop_iterations,
    get_eigvals,
    create_grid_data,
    convert_data_to_dataframe_python,
    convert_data_to_dataframe,
    find_bifurcations_parameter_grid,
    compare_stability,
    get_combined_state_space_eigenvalue_distance,
    get_minimal_state_space_distances,
    get_minimal_eigenvalue_distances,
    find_bifurcations_trajectory,
    construct_relu_matrix_list_exhaustive,
    get_unique_number_linear_regions


include("helpers.jl")
include("helpers_bifurcation.jl")
include("exhaustive_search.jl")
end