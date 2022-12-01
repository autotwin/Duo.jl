using Test

using Duo
# import Pkg;
# Pkg.add("duo");
# include("duo.jl")

@testset "Duo.jl" begin
    # Write your tests here.
    known = "Hello Julia!"
    @test known == greeting()

    """
    y
    ^
    |     *-----------*
    |     |  x     x  |
    *-----1-----2-----3-----4--> x
    |     |  x     x  |
    |     *-----------*
    """

    pt = Point2D(2.0, 0.0)
    inscribed_diameter = 2.0

    root = Cell2D(pt, inscribed_diameter)
    @test root.center == pt
    @test root.size == 2.0

    # https://github.com/sandialabs/sibl/blob/b7ea9686fb9a7895018f0154e04aa67df5a902a3/geo/tests/test_quadtree.py#L72

    @testset "boundary" begin
        @test extents(root) == ((1.0, -1.0), (3.0, 1.0))

        # y constant, delta x
        @test contains(root, Point2D(0.9, 0.0)) == false
        @test contains(root, Point2D(1.0, 0.0))
        @test contains(root, Point2D(1.1, 0.0))

        @test contains(root, Point2D(2.9, 0.0))
        @test contains(root, Point2D(3.0, 0.0))
        @test contains(root, Point2D(3.1, 0.0)) == false

        # x constant, delta y
        @test contains(root, Point2D(2.0, -1.1)) == false
        @test contains(root, Point2D(2.0, -1.0))
        @test contains(root, Point2D(2.0, -0.9))

        @test contains(root, Point2D(2.0, 0.9))
        @test contains(root, Point2D(2.0, 1.0))
        @test contains(root, Point2D(2.1, 1.01)) == false

        # four corners
        @test contains(root, Point2D(1.0, -1.0))
        @test contains(root, Point2D(3.0, -1.0))
        @test contains(root, Point2D(3.0, 1.0))
        @test contains(root, Point2D(1.0, 1.0))
    end # boundary

    @testset "hierarchy and division" begin
        # no parent, no children
        # https://docs.julialang.org/en/v1/base/base/#Core.:===

        # @test duo.parent(root) === nothing
        @test isnothing(parent(root))

        # @test children(root) === nothing
        @test isnothing(children(root))

        @test Duo.has_children(root) == false

        @test Duo.is_root(root)

        # grow hierarchy by one level
        divide!(root)
        @test root.level == 0
        @test has_children(root)
        sw, se, ne, nw = children(root)

        @test sw.center == Point2D(1.5, -0.5)
        @test sw.size == 1.0
        @test sw.level == 1
        @test sw.parent === root
        @test isnothing(sw.children)

        @test se.center == Point2D(2.5, -0.5)
        @test se.size == 1.0
        @test se.level == 1
        @test se.parent === root
        @test isnothing(se.children)

        @test ne.center == Point2D(2.5, 0.5)
        @test ne.size == 1.0
        @test ne.level == 1
        @test ne.parent === root
        # @test isnothing(ne.children)
        @test ne.children |> isnothing

        @test nw.center == Point2D(1.5, 0.5)
        @test nw.size == 1.0
        @test nw.level == 1
        @test nw.parent === root
        @test isnothing(nw.children)

        # Testing and implementation of divide!
        # see
        # https://github.com/JuliaLang/julia/issues/269#issuecomment-441829356

    end # hierarchy
end # Duo.jl
