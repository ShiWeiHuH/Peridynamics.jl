@testitem "uniform_box" begin
    pos, vol = uniform_box(1, 1, 1, 0.5)
    @test pos == [
        -0.25   0.25  -0.25   0.25  -0.25   0.25  -0.25  0.25
        -0.25  -0.25   0.25   0.25  -0.25  -0.25   0.25  0.25
        -0.25  -0.25  -0.25  -0.25   0.25   0.25   0.25  0.25
    ]
    @test vol == fill(0.125, 8)

    pos, vol = uniform_box(1, 1, 1, 0.5; center_x=1, center_y=1, center_z=1)
    @test pos == [
        0.75  1.25  0.75  1.25  0.75  1.25  0.75  1.25
        0.75  0.75  1.25  1.25  0.75  0.75  1.25  1.25
        0.75  0.75  0.75  0.75  1.25  1.25  1.25  1.25
    ]
    @test vol == fill(0.125, 8)
end

@testitem "uniform_sphere" begin
    pos, vol = uniform_sphere(1, 0.5)
    @test pos == [
        -0.25   0.25  -0.25   0.25  -0.25   0.25  -0.25  0.25
        -0.25  -0.25   0.25   0.25  -0.25  -0.25   0.25  0.25
        -0.25  -0.25  -0.25  -0.25   0.25   0.25   0.25  0.25
    ]
    @test vol == fill(0.125, 8)

    pos, vol = uniform_sphere(1, 0.5; center_x=1, center_y=1, center_z=1)
    @test pos == [
        0.75  1.25  0.75  1.25  0.75  1.25  0.75  1.25
        0.75  0.75  1.25  1.25  0.75  0.75  1.25  1.25
        0.75  0.75  0.75  0.75  1.25  1.25  1.25  1.25
    ]
    @test vol == fill(0.125, 8)
end

@testitem "uniform_cylinder" begin
    pos, vol = Peridynamics.uniform_cylinder(1, 2, 0.5)
    @test pos ≈ [
        -0.25   0.25  -0.25   0.25  -0.25   0.25  -0.25   0.25  -0.25   0.25  -0.25  0.25  -0.25   0.25  -0.25  0.25
        -0.25  -0.25   0.25   0.25  -0.25  -0.25   0.25   0.25  -0.25  -0.25   0.25  0.25  -0.25  -0.25   0.25  0.25
        -0.75  -0.75  -0.75  -0.75  -0.25  -0.25  -0.25  -0.25   0.25   0.25   0.25  0.25   0.75   0.75   0.75  0.75
    ]
    @test vol == fill(0.125, 16)

    pos, vol = Peridynamics.uniform_cylinder(1, 2, 0.5; center_position=(1, 2, 1))
    @test pos ≈ [
        0.75   1.25  0.75   1.25  0.75   1.25  0.75   1.25  0.75   1.25  0.75  1.25  0.75   1.25  0.75  1.25
        1.75  1.75   2.25   2.25  1.75  1.75   2.25   2.25  1.75  1.75   2.25  2.25  1.75  1.75   2.25  2.25
        0.25  0.25  0.25  0.25  0.75  0.75  0.75  0.75   1.25   1.25   1.25  1.25   1.75   1.75   1.75  1.75
    ]
    @test vol == fill(0.125, 16)
end


@testitem "round_sphere" begin
    pos, vol = Peridynamics.round_sphere(1.6, 0.5)
    @test pos ≈ [
        0.0 0.0 0.47533372629569887 0.23766686314784938 -0.23766686314784954 -0.47533372629569887 -0.23766686314784924 0.2376668631478495 0.492143194265497 0.30684626267871895 -0.10951216322820224 -0.4434056965832651 -0.4434056965832652 -0.10951216322820236 0.30684626267871884 0.0;
        0.0 0.0 0.0 0.4116510822475945 0.41165108224759445 5.821159264348117e-17 -0.41165108224759456 -0.41165108224759445 0.0 0.3847730431591451 0.47980413687975465 0.2135329293091727 -0.2135329293091726 -0.47980413687975465 -0.3847730431591452 0.0;
        0.0 0.55 0.276690890066597 0.276690890066597 0.276690890066597 0.276690890066597 0.276690890066597 0.276690890066597 -0.24555055760098224 -0.24555055760098224 -0.24555055760098224 -0.24555055760098224 -0.24555055760098224 -0.24555055760098224 -0.24555055760098224 -0.55
    ]
    @test vol == fill(0.13404128655316452, 16)

    pos, vol = Peridynamics.round_sphere(1, 0.5)
    @test pos ≈ [
        0.25 -0.125 -0.125;
        0.0 0.21650635094610968 -0.21650635094610968;
        0.0 0.0 0.0
    ]
    @test vol == fill(0.17453292519943295, 3)

    pos, vol = Peridynamics.round_sphere(0.8, 0.5)
    @test pos ≈ [
        0.0
        0.0
        0.0
    ]
    @test vol == fill(0.26808257310632905, 1)

    pos, vol = Peridynamics.round_sphere(1.6, 0.5; center_position=(1, 2, 3))
    @test pos ≈ [
        1.0 1.0 1.475333726295699 1.2376668631478493 0.7623331368521504 0.5246662737043011 0.7623331368521508 1.2376668631478496 1.492143194265497 1.306846262678719 0.8904878367717978 0.5565943034167349 0.5565943034167349 0.8904878367717977 1.306846262678719 1.0;
        2.0 2.0 2.0 2.4116510822475945 2.4116510822475945 2.0 1.5883489177524055 1.5883489177524055 2.0 2.384773043159145 2.4798041368797548 2.2135329293091726 1.7864670706908274 1.5201958631202452 1.6152269568408548 2.0;
        3.0 3.55 3.2766908900665968 3.2766908900665968 3.2766908900665968 3.2766908900665968 3.2766908900665968 3.2766908900665968 2.7544494423990176 2.7544494423990176 2.7544494423990176 2.7544494423990176 2.7544494423990176 2.7544494423990176 2.7544494423990176 2.45
    ]
    @test vol == fill(0.13404128655316452, 16)

    pos, vol = Peridynamics.round_sphere(1, 0.5; center_position=(1, 2, 3))
    @test pos ≈ [
        1.25 0.875 0.875;
        2.0 2.21650635094611 1.7834936490538904;
        3.0 3.0 3.0
    ]
    @test vol == fill(0.17453292519943295, 3)

    pos, vol = Peridynamics.round_sphere(0.8, 0.5; center_position=(1, 2, 3))
    @test pos ≈ [
        1.0
        2.0
        3.0
    ]
    @test vol == fill(0.26808257310632905, 1)
end

@testitem "round_cylinder" begin
    pos, vol = Peridynamics.round_cylinder(1, 2, 0.5)
    @test pos ≈ [
        0.25 -0.12499999999999994 -0.1250000000000001 0.25 -0.12499999999999994 -0.1250000000000001 0.25 -0.12499999999999994 -0.1250000000000001 0.25 -0.12499999999999994 -0.1250000000000001 0.25 -0.12499999999999994 -0.1250000000000001;
        0.0 0.21650635094610968 -0.21650635094610962 0.0 0.21650635094610968 -0.21650635094610962 0.0 0.21650635094610968 -0.21650635094610962 0.0 0.21650635094610968 -0.21650635094610962 0.0 0.21650635094610968 -0.21650635094610962;
        -1.0 -1.0 -1.0 -0.5 -0.5 -0.5 0.0 0.0 0.0 0.5 0.5 0.5 1.0 1.0 1.0
    ]
    @test vol == fill(0.20943951023931953, 15)

    pos, vol = Peridynamics.round_cylinder(1, 2, 0.5; center_position=(1, 2, 1))
    @test pos ≈ [
        1.25 0.875 0.8749999999999999 1.25 0.875 0.8749999999999999 1.25 0.875 0.8749999999999999 1.25 0.875 0.8749999999999999 1.25 0.875 0.8749999999999999;
        2.0 2.21650635094611 1.7834936490538904 2.0 2.21650635094611 1.7834936490538904 2.0 2.21650635094611 1.7834936490538904 2.0 2.21650635094611 1.7834936490538904 2.0 2.21650635094611 1.7834936490538904;
        0.0 0.0 0.0 0.5 0.5 0.5 1.0 1.0 1.0 1.5 1.5 1.5 2.0 2.0 2.0
    ]
    @test vol == fill(0.20943951023931953, 15)
end
