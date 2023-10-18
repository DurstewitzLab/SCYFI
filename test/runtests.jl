using SCYFI
using Test
include("./convPLRNN_tests.jl")
include("./shPLRNN_tests.jl")

@testset "SCYFI.jl" begin 
    #conv PLRNN
    test_finding_1_cycle_2D_for_holes()
    test_finding_1_cycle_2D()
    test_finding_1_cycle_2D_val()
    test_finding_16_cycle_2D()
    test_finding_16_cycle_2D_nothing()
    test_finding_27_cycle_2D()
    test_finding_27_cycle_2D_nothing()
    test_finding_31_cycle_2D()
    test_finding_31_cycle_2D_nothing()
    test_finding_40_cycle_2D()
    test_finding_40_cycle_2D_nothing()
    test_finding_53_cycle_2D()
    test_finding_53_cycle_2D_nothing()
    test_finding_65_cycle_2D()
    test_finding_65_cycle_2D_nothing()
    test_finding_80_cycle_2D()
    test_finding_80_cycle_2D_nothing()
    test_finding_83_cycle_2D()
    test_finding_83_cycle_2D_nothing()
    test_finding_10_cycle_10D()
    test_finding_10_cycle_10D_nothing()

    #shPLRNN
    test_finding_1_cycle_M2_H10()
    test_finding_1_cycle_M2_H10_val()
    test_finding_2_cycle_4_cycle_M2_H10()
    test_finding_2_cycle_4_cycle_M2_H10_nothing()
end
