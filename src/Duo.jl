module Duo

import Base: contains, parent
# Want `import` to have it in my local scope so that I can add a new method to Base: contains

"""Refactor of 2D dualization in Python
Reference:
https://github.com/sandialabs/sibl/blob/b7ea9686fb9a7895018f0154e04aa67df5a902a3/geo/src/ptg/quadtree.py#L12
"""

# Documentation refernce:
# https://docs.julialang.org/en/v1/manual/documentation/

export greeting, Point2D, Cell2D, contains, extents, has_children, children, parent, divide!

"""
    Point2D

A coordinate with `x` and `y` values measured from an origin.
"""
struct Point2D
    x::Real
    y::Real
end

"""
    Cell2D

A square shape domain centered at `Point2D` with side length of `size`,
equal to the square's width and height.

The `level` is the number of cell divisions that have occurred to create
the subject `cell`; root cells by definition have `level = 0`.

The `parent` is the cell that sits above the current subject cell in the
hierarchy.  A root cell has no parent by definition.  A non-root (child)
cell must have a non-nothing parent.

The `children` are either nothing or the four children cells sitting below
the current subject cell in the hierarchy.
"""
mutable struct Cell2D
    center::Point2D
    size::Real
    level::Int
    parent::Union{Cell2D,Nothing}
    children::Union{Vector{Cell2D},Nothing}
    # Cell2D(center::Point2D, size::Real) = new(center, size, Nothing, Nothing)
end

function Cell2D(center::Point2D, size::Real)
    root_level = 0
    return Cell2D(center, size, root_level, nothing, nothing)
end

function _bounds(cell::Cell2D)
    half_size = cell.size / 2.0
    xmax = cell.center.x + half_size
    xmin = cell.center.x - half_size

    ymax = cell.center.y + half_size
    ymin = cell.center.y - half_size
    return (xmin, xmax, ymin, ymax)
end

"""
    contains(cell, point)

Determines if the coordinates of a `point` lie on or within the boundary of a `cell`.

Returns `true` if the point is on the boundary of the cell or in
the interior of the cell; `false` otherwise.
"""
function contains(cell::Cell2D, point::Point2D)
    xmin, xmax, ymin, ymax = _bounds(cell)

    left = point.x ≥ xmin
    right = point.x ≤ xmax

    bottom = point.y ≥ ymin
    top = point.y ≤ ymax

    # return point.x ≥ xmin && point.x ≤ xmax && point.y ≥ ymin && point.y ≤ ymax
    return all([left, right, bottom, top])
end

"""
    parent(cell)

Get the parent cell of the current subject cell `cell`.
"""
@inline parent(cell::Cell2D) = cell.parent

"""
    children(cell)

Get the children (cells) of the current subject cell `cell`.

Prior to cell division, the cell has no children.
After cell division in 2D, the cell has exactly four children.
After cell division in 3D, the cell has exactly eight children.
"""
@inline children(cell::Cell2D) = cell.children

"""
    has_children(cell)

Whether or not the subject `cell` has children.  Returns `true` if
the cell has children; `false` if the cell has no children.
"""
@inline has_children(cell::Cell2D) = !(children(cell) === nothing)

"""
    is_root(cell)

Whether or not the subject `cell` is the root of the cell hierarchy.
Returns `true` if the cell is the root; `false` otherwise.
"""
@inline is_root(cell::Cell2D) = (cell.level == 0) && (isnothing(cell.parent))

"""
    extents(cell)

In 2D, returns the left/lower corner (xmin, ymin) and the
right/upper corner (xmax, ymax) as a tuple ((xmin, ymin), (xmax, ymax)).
"""
function extents(cell::Cell2D)
    xmin, xmax, ymin, ymax = _bounds(cell)
    return ((xmin, ymin), (xmax, ymax))
end

"""
    divide!(cell)

Causes the `cell` to undergo cell division.  In 2D, causes the current
subject cell to have four children.
"""
function divide!(cell::Cell2D)
    # (X, Y) are the coordinates of the center of the cell, with inscribed
    # circle metric of radius R.
    X = cell.center.x
    Y = cell.center.y
    R = cell.size / 2.0  # cell.size is equivalent to inscribed diameter

    # Four new cells are created in each of the four corners,
    # southwest, southeast, northeast, and northwest, 
    # with new radius that is half of the parent radius, and four
    # centers located in the inscribed circle center of each of the sw,
    # se, ne, and nw child cells.
    r = R / 2.0

    west = X - r # x coordinate
    east = X + r # x coordinate

    south = Y - r # y coordinate
    north = Y + r # y coordinate

    sw = Point2D(west, south)
    se = Point2D(east, south)
    ne = Point2D(east, north)
    nw = Point2D(west, north)

    child_size = R
    child_level = cell.level + 1

    child_sw = Cell2D(sw, child_size, child_level, cell, nothing)
    child_se = Cell2D(se, child_size, child_level, cell, nothing)
    child_ne = Cell2D(ne, child_size, child_level, cell, nothing)
    child_nw = Cell2D(nw, child_size, child_level, cell, nothing)

    # mutate the parent cell
    return cell.children = [child_sw, child_se, child_ne, child_nw]
end

# Write your package code here.
function greeting()
    return "Hello Julia!"
end

end # module duo
