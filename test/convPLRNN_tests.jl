using Test

function test_finding_1_cycle_2D_for_holes()
    # define variables for GT sys with 1 cycle if
    a2 = -0.7 
    a1 = 0.69999999999999999999999999999
    w1 = -0.14375
    w2 = 0.52505308
    h1 = 0.37298253
    h2 = -0.97931491
    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 1
    FPs,eigenvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=20)
    #println(FPs[1][1])
    @test length(FPs[1][1]) == 1
end

function test_finding_1_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = -0.022231099999999948
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491
    z1 = 0.4967141530112327
    z2 = -0.13826430117118466

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 1
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=20)
    #println(FPs[1][1])
    @test length(FPs[1][1]) == 1
end

function test_finding_1_cycle_2D_val()
    # define variables for GT sys with 1 cycle if
    a1 = -0.022231099999999948
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491
    z1 = 0.4967141530112327
    z2 = -0.13826430117118466

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 1
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=20)
    #println(FPs[1][1])
    @test round.(FPs[1][1][1],digits=2) == [0.36, -22.26]
end


function test_finding_16_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.8377689000000008
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 16
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[16])
    @test length(FPs[16]) == 2
end

function test_finding_16_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.8377689000000008
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 16
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[16])
    @test length(FPs[15]) == 0
end

function test_finding_27_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.52505308
    h1 = 0.37298253
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 27
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[25])
    @test length(FPs[27]) == 2
end

function test_finding_27_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.52505308
    h1 = 0.37298253
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 27
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[25])
    @test length(FPs[25]) == 0
end

function test_finding_31_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 1.1750530800000014
    h1 = 0.37298253
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 31
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[31])
    @test length(FPs[31]) == 2
end


function test_finding_31_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 1.1750530800000014
    h1 = 0.37298253
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 31
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[25])
    @test length(FPs[30]) == 0
end

function test_finding_40_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 40
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[31])
    @test length(FPs[40]) == 2
end


function test_finding_40_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491

    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 40
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[31])
    @test length(FPs[38]) == 0
end

function test_finding_53_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9377689000000009
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 53
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[31])
    @test length(FPs[53]) == 2
end

function test_finding_53_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9377689000000009
    a2 = 0.96461297
    w1 = -0.6437499999999996
    w2 = 0.52505308
    h1 = 0.37298253000000087
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 53
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=10,inner_loop_iterations=50)
    #println(FPs[31])
    @test length(FPs[50]) == 0
end

function test_finding_65_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 1.3250530800000015
    h1 = 0.37298253
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 65
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=60)
    #println(FPs[31])
    @test length(FPs[65]) == 2
end

function test_finding_65_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 1.3250530800000015
    h1 = 0.37298253
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 65
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=60)
    #println(FPs[31])
    @test length(FPs[60]) == 0
end


function test_finding_80_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.52505308
    h1 = 0.37298253
    h2 = -0.779314909999999


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 80
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=100)
    #println(FPs[31])
    @test length(FPs[80]) == 2
end

function test_finding_80_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.52505308
    h1 = 0.37298253
    h2 = -0.779314909999999


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 80
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=100)
    #println(FPs[31])
    @test length(FPs[70]) == 0
end

function test_finding_83_cycle_2D()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.675053080000001
    h1 = 0.37298253
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 83
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=100)
    #println(FPs[31])
    @test length(FPs[83]) == 2
end

function test_finding_83_cycle_2D_nothing()
    # define variables for GT sys with 1 cycle if
    a1 = 0.9777689
    a2 = 0.96461297
    w1 = -0.14375
    w2 = 0.675053080000001
    h1 = 0.37298253
    h2 = -0.97931491


    A = [a1 0; 0 a2]
    W = [0 w1; w2 0]
    h = [h1, h2]
    dz = 2
    k = 83
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=100)
    #println(FPs[31])
    @test length(FPs[80]) == 0
end

function test_finding_10_cycle_10D()
    # define variables for GT sys with 1 cycle if
    A=[0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334]
    W=[1.7141654 0.90136945 0.7356431 -0.45661467 -1.0216872 -2.1104505 -0.1265201 0.8208984 -0.16492529 0.10196607; 1.2489663 0.36885896 0.47238302 -0.4648625 -0.8395844 -1.6625919 -0.27828497 0.4668116 0.2430289 0.43664113; 0.4888246 0.31421587 0.061512344 0.03574979 -0.43089348 -0.9017075 0.06113107 0.45323887 -0.12256672 -0.22407334; -0.8275283 -0.6372472 -0.6524501 0.5350839 0.143212 0.3879285 0.17147072 0.18457298 0.33618844 -0.31503707; 0.4699096 0.36021802 0.40548527 -0.773131 -0.41375652 -0.45799288 -0.33785427 0.0071197264 -0.12557332 0.4461898; 1.7938753 0.933799 0.9427183 -0.4197829 -1.0978042 -2.340497 -0.60876435 0.8649732 -0.11037506 0.4225005; -0.46095127 -0.282801 -0.14612287 0.23626074 0.43258965 0.68257767 0.36670405 -0.25161934 0.1560926 -0.09981756; -0.1794313 -0.046297066 -0.23596726 0.60501343 0.077439524 -0.037234787 0.18110584 0.3498277 -0.007887238 -0.4353217; -0.3996467 -0.28196895 -0.1993325 -0.027839307 0.20849963 0.4165471 0.17119904 -0.2667973 0.25180992 0.13836445; 0.4042766 0.52036214 0.21992852 -0.1569775 0.024118641 -0.08136176 -0.20892598 -0.1640525 -0.3731168 0.09140323]
    h=[-0.25387551903975236, -0.12912468150368078, -0.3746121660912428, 0.5381540053468717, 0.13797574730440254, -0.9145060467607822, -0.47008295657633226, 0.23037773308426446, 0.5373384681742799, 0.32054443856805936]
    cycles, eigenvals =find_cycles(A, W, h,10,outer_loop_iterations=100,inner_loop_iterations=500)
    dz = 10
    k = 10
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=80)
    #println(FPs[10])
    @test length(FPs[10]) == 2
end

function test_finding_10_cycle_10D_nothing()
    # define variables for GT sys with 1 cycle if
    A=[0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.09658233076334]
    W=[1.7141654 0.90136945 0.7356431 -0.45661467 -1.0216872 -2.1104505 -0.1265201 0.8208984 -0.16492529 0.10196607; 1.2489663 0.36885896 0.47238302 -0.4648625 -0.8395844 -1.6625919 -0.27828497 0.4668116 0.2430289 0.43664113; 0.4888246 0.31421587 0.061512344 0.03574979 -0.43089348 -0.9017075 0.06113107 0.45323887 -0.12256672 -0.22407334; -0.8275283 -0.6372472 -0.6524501 0.5350839 0.143212 0.3879285 0.17147072 0.18457298 0.33618844 -0.31503707; 0.4699096 0.36021802 0.40548527 -0.773131 -0.41375652 -0.45799288 -0.33785427 0.0071197264 -0.12557332 0.4461898; 1.7938753 0.933799 0.9427183 -0.4197829 -1.0978042 -2.340497 -0.60876435 0.8649732 -0.11037506 0.4225005; -0.46095127 -0.282801 -0.14612287 0.23626074 0.43258965 0.68257767 0.36670405 -0.25161934 0.1560926 -0.09981756; -0.1794313 -0.046297066 -0.23596726 0.60501343 0.077439524 -0.037234787 0.18110584 0.3498277 -0.007887238 -0.4353217; -0.3996467 -0.28196895 -0.1993325 -0.027839307 0.20849963 0.4165471 0.17119904 -0.2667973 0.25180992 0.13836445; 0.4042766 0.52036214 0.21992852 -0.1569775 0.024118641 -0.08136176 -0.20892598 -0.1640525 -0.3731168 0.09140323]
    h=[-0.25387551903975236, -0.12912468150368078, -0.3746121660912428, 0.5381540053468717, 0.13797574730440254, -0.9145060467607822, -0.47008295657633226, 0.23037773308426446, 0.5373384681742799, 0.32054443856805936]
    cycles, eigenvals =find_cycles(A, W, h,10,outer_loop_iterations=100,inner_loop_iterations=500)
    dz = 10
    k = 10
    FPs,eigvals = find_cycles(A, W, h,k,outer_loop_iterations=20,inner_loop_iterations=80)
    #println(FPs[10])
    @test length(FPs[9]) == 0
end
