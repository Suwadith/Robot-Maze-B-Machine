/* Maze
 * Author: Suwadith
 * Creation date: 12/17/2019
 */
MACHINE
    Maze
    
CONSTANTS
    x_axis_range,
    y_axis_range,
    maze,
    internal_walls,
    entrance_square,
    exit_square
    
PROPERTIES
    x_axis_range <: NATURAL1 & x_axis_range = 1..7 & 
    y_axis_range <: NATURAL1 & y_axis_range = 1..5 &
    maze : x_axis_range <-> y_axis_range &
    maze = x_axis_range * y_axis_range &
    internal_walls : x_axis_range <-> y_axis_range &
    internal_walls = {
        (2 |-> 1),(6 |-> 1),(4 |-> 2),(6 |-> 2),(1 |-> 3),(2 |-> 3),(3 |-> 3),(4 |-> 3),(4 |-> 4),(6 |-> 4),(7 |-> 4),(2 |-> 5)
    } &
    entrance_square : x_axis_range <-> y_axis_range &
    entrance_square = {(1 |-> 1)} &
    exit_square : x_axis_range <-> y_axis_range &
    exit_square = {(1 |-> 5)}
    
END
