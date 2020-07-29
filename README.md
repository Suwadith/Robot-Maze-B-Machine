# Robot-Maze-B-Machine
A B-specification of a Robot moving around a simple Maze, using the B tools (Atelier B &amp; ProB)

The figure below gives the layout of the rectangular shaped maze, the Robot is represented by "•" & its starting
position is the entry square (1, 1).

The aim is to move the robot from the entry square through the maze using the various movement operations
to get to the exit square of the maze (1, 5).

![1](https://github.com/Suwadith/Robot-Maze-B-Machine/blob/master/Images/1.png)

## Notes

* The squares of the maze form a grid of squares 7 wide by 5 high.
* The robot occupies only one square at a time & can only be in an "empty maze square", i.e. a square inside the maze and not one of the maze's internal walls. For example, the robot can be in square (5, 3), one of the maze's "path" squares, but not (4, 2) an "internal wall" square.
* The robot starts off in the entrance square, i.e. the bottom left square (1, 1).
* The robot can be moved around the maze by using one of four directions: North ↑, South ↓, East → and West ←; or it can "teleport" to one of the maze's "path" squares.

## Robot Movement Operations in the Maze

* The following operations are the basic movements that all move the robot one square in the appropriate direction in the maze.
1. MoveNorth
2. MoveSouth
3. MoveEast
4. MoveWest

* Note that if any attempted movement can not be performed, either because of the boundary wall of the maze, i.e. attempting to move North when in square (4, 5), or an internal maze wall, i.e. attempting to move East when in square (3, 2), then an error message is output indicating the reason it could not make the move.
* The Robot can also "teleport" to a "path" square within the maze.

5. Teleport

* The operation inputs a square that the Robot attempts to teleport to. If the input square is suitable for the Robot to teleport to it does so and reports success. However, if it is not a suitable square for it to teleport to, it outputs an error message indicating why.
* Note that all operations must report the outcome of an attempted movement, that is, either it was successful, failed due to the maze's boundary, failed due to an internal wall, or for some other reason.

## Enquiry Operations about Robot in the Maze

1. getPosition - outputs the current position of the robot in the maze.
2. foundExit - outputs yes if the robot is currently in the exit square of the maze, no otherwise.
3. visitedSquare - inputs a square and reports yes if the current square has been visited by the robot, no otherwise. Note that a square is designated as being visited by the Robot if it has been on the square more than once. That is, a square "has been visited" only after the robot has moved off it.
4. robotsRoute - outputs the sequence of squares the Robot has visited, in the order visited, i.e. its route through the maze.

## Structure Diagram

![2](https://github.com/Suwadith/Robot-Maze-B-Machine/blob/master/Images/2.png)

