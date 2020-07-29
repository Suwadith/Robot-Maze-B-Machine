/* Robot
 * Author: Suwadith
 * Creation date: 12/15/2019
 */


/*  Operations

    MoveNorth:
    Moves the robot 1 square towards North by increasing the current y axis value by 1. (y+1)

    MoveEast:
    Moves the robot 1 square towards East by increasing the current x axis value by 1. (x+1)

    MoveSouth:
    Moves the robot 1 square towards South by decreasing the current y axis value by 1. (y-1)

    MoveWest:
    Moves the robot 1 square towards West by decreasing the current x axis value by 1. (x-1)

    Teleport:
    Teleports the robot from one square to another square where the squares are both empty (Non Internal Walls).
    Teleport only works after an initial movement has been made. (E.g:- After the first MoveNorth Operation)

    getPosition:
    Returns the current position of the robot (x |-> y)

    foundExit:
    Returns yes/no depending on whether the robot has reached the exit square or not.

    visitedSquare:
    Returns whether the robot has visited a given square already (yes/no) 
    
    robotsRoute:
    Returns the sequence of the path that the robot has gone through ({(1 |-> (x1 |-> y1)), (2 |-> (x2 |-> y2))})

*/

MACHINE
    Robot
    
SEES
    Maze
    
SETS
    REPORT = {Exceeding_Maze_Boundary, Maze_Wall_Crash, Moved_North, Moved_East, Moved_South, Moved_West, Cannot_Teleport_Immediately, Cannot_Teleport_To_The_Same_Square, Teleported, yes, no}
    // ENQUIRY = {yes, no}
    
VARIABLES
    robotXPosition,
    robotYPosition,
    currentPosition,
    visitedSquares
    
INVARIANT
    // Robot's x-axis position is within the Maze's x-axis range (1-7)
    robotXPosition : x_axis_range &
    // Robot's y-axis position is within the Maze's y-axis range (1-5)
    robotYPosition : y_axis_range &
    // current position of the Robot (maplet (x |-> y)) is an element of the maze
    currentPosition : maze &
    // squares which have been visited by the Robot is stored as a sequence of Maze maplets 
    visitedSquares : seq(maze)
    
INITIALISATION
    // Initializes all the position related variables by assigning (1, 1) as the initial suqare
    robotXPosition := 1 ||
    robotYPosition := 1 ||
    currentPosition := ( 1 |-> 1 ) ||
    visitedSquares := [( 1 |-> 1 )]
    
OPERATIONS
    
    report <-- MoveNorth = 
        PRE report : REPORT
        THEN
            // Checks whether the square above the current position is within the maze 
            IF (robotYPosition + 1 > max(y_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            // Checks whether the square above the current position is not an internal wall
            ELSIF ((robotXPosition |-> robotYPosition + 1) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition |-> robotYPosition + 1)) ||
                currentPosition := (robotXPosition |-> robotYPosition + 1) ||
                robotYPosition := robotYPosition + 1 ||
                report := Moved_North
            END
        END;


    report <-- MoveEast = 
        PRE report : REPORT
        THEN
            // Checks whether the square to the right of the current position is within the maze 
            IF (robotXPosition + 1 > max(x_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            // Checks whether the square to the right of the current position is not an internal wall
            ELSIF ((robotXPosition + 1 |-> robotYPosition) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition + 1 |-> robotYPosition)) ||
                currentPosition := (robotXPosition + 1 |-> robotYPosition) ||
                robotXPosition := robotXPosition + 1 ||
                report := Moved_East
            END
        END;


    report <-- MoveSouth = 
        PRE report : REPORT
        THEN
            // Checks whether the square below the current position is within the maze
            IF (robotYPosition - 1 < min(y_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            // Checks whether the square below the current position is not an internal wall
            ELSIF ((robotXPosition |-> robotYPosition - 1) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition |-> robotYPosition - 1)) ||
                currentPosition := (robotXPosition |-> robotYPosition - 1) ||
                robotYPosition := robotYPosition - 1 ||
                report := Moved_South
            END        
        END;


        report <-- MoveWest = 
            PRE report : REPORT
            THEN
                // Checks whether the square to the left of the current position is within the maze 
                IF (robotXPosition - 1 < min(x_axis_range))
                THEN 
                    report := Exceeding_Maze_Boundary
                // Checks whether the square to the left of the current position is not an internal wall
                ELSIF ((robotXPosition - 1 |-> robotYPosition) : internal_walls) 
                THEN 
                    report := Maze_Wall_Crash
                ELSE 
                    visitedSquares := (visitedSquares <- (robotXPosition - 1 |-> robotYPosition)) ||
                    currentPosition := (robotXPosition - 1 |-> robotYPosition) ||
                    robotXPosition := robotXPosition - 1 ||
                    report := Moved_West
                END
            END;


        report <-- Teleport(teleportXPosition, teleportYPosition) =
            PRE report : REPORT & teleportXPosition : NATURAL1 & teleportYPosition : NATURAL1
            THEN
                // Makes sure that this is not the first move
                IF (size(visitedSquares) = 1) 
                THEN 
                    report := Cannot_Teleport_Immediately
                // Makes sure that the robot doesn't teleport to an internal wall
                ELSIF ((teleportXPosition |-> teleportYPosition) : internal_walls)
                THEN 
                    report := Maze_Wall_Crash
                // Makes sure that the robot doesn't teleport to the same current square
                ELSIF (teleportXPosition = robotXPosition & teleportYPosition = robotYPosition)
                THEN
                    report := Cannot_Teleport_To_The_Same_Square
                // Makes sure that the robot doesn't teleport itself out of the maze
                ELSIF ((teleportXPosition |-> teleportYPosition) /: maze)
                THEN
                    report := Exceeding_Maze_Boundary
                ELSE
                    visitedSquares := (visitedSquares <- (teleportXPosition |-> teleportYPosition)) ||
                    currentPosition := (teleportXPosition |-> teleportYPosition) ||
                    robotXPosition := teleportXPosition ||
                    robotYPosition := teleportYPosition ||
                    report := Teleported
                END
            END;


        position <-- getPosition =
            BEGIN 
            position := currentPosition
            END;


        enquiry <-- foundExit = 
            PRE enquiry : REPORT
            THEN
                // Checks if the robot's current position is the exit square
                IF (currentPosition : exit_square)
                THEN 
                    enquiry := yes
                ELSE 
                    enquiry := no
                END
            END;


        visited <-- visitedSquare(visitedXPosition, visitedYPosition) =
            PRE visited : REPORT & visitedXPosition : NATURAL1 & visitedYPosition : NATURAL1
            THEN
                // Makes sure that the visited square x,y coordinates are within the maze
                IF ((visitedXPosition |-> visitedYPosition) : maze)
                THEN 
                    // Checks if the robot has already visited a particular square (Doesn't include the current square, but all the previouse squares)
                    IF ((visitedXPosition |-> visitedYPosition) : ran(front(visitedSquares)))
                    THEN 
                        visited := yes
                    ELSE
                        visited := no
                    END
                ELSE
                    visited := Exceeding_Maze_Boundary
                END
            END;


        route <-- robotsRoute =
            BEGIN
                route := visitedSquares
            END
    
END