/* Robot
 * Author: Suwadith
 * Creation date: 12/18/2019
 */
MACHINE
    Robot
    
SEES
    Maze
    
SETS
    REPORT = {Exceeding_Maze_Boundary, Maze_Wall_Crash, Moved_North, Moved_East, Moved_South, Moved_West, Cannot_Teleport_Immediately, Cannot_Teleport_To_The_Same_Square, Teleported};
    ENQUIRY = {yes, no}
    
VARIABLES
    robotXPosition,
    robotYPosition,
    currentPosition,
    visitedSquares
    
INVARIANT
    robotXPosition : x_axis_range &
    robotYPosition : y_axis_range &
    currentPosition : maze &
    visitedSquares : seq(maze)
    
INITIALISATION
    robotXPosition := 1 ||
    robotYPosition := 1 ||
    currentPosition := ( 1|-> 1 ) ||
    visitedSquares := [( 1|-> 1 )]
    
OPERATIONS

    report <-- MoveNorth = 
        PRE report : REPORT
        THEN
            IF (robotYPosition+1 > max(y_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            ELSIF ((robotXPosition |-> robotYPosition+1) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition |-> robotYPosition+1)) ||
                currentPosition := (robotXPosition |-> robotYPosition+1) ||
                robotYPosition := robotYPosition+1 ||
                report := Moved_North
            END
        END;


    report <-- MoveEast = 
        PRE report : REPORT
        THEN
            IF (robotXPosition+1 > max(x_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            ELSIF ((robotXPosition+1 |-> robotYPosition) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition+1 |-> robotYPosition)) ||
                currentPosition := (robotXPosition+1 |-> robotYPosition) ||
                robotXPosition := robotXPosition+1 ||
                report := Moved_East
            END
        END;


    report <-- MoveSouth = 
        PRE report : REPORT
        THEN
            IF (robotYPosition-1 < min(y_axis_range))
            THEN 
                report := Exceeding_Maze_Boundary
            ELSIF ((robotXPosition |-> robotYPosition-1) : internal_walls) 
            THEN 
                report := Maze_Wall_Crash
            ELSE 
                visitedSquares := (visitedSquares <- (robotXPosition |-> robotYPosition-1)) ||
                currentPosition := (robotXPosition |-> robotYPosition-1) ||
                robotYPosition := robotYPosition-1 ||
                report := Moved_South
            END        
        END;


        report <-- MoveWest = 
            PRE report : REPORT
            THEN
                IF (robotXPosition-1 < min(x_axis_range))
                THEN 
                    report := Exceeding_Maze_Boundary
                ELSIF ((robotXPosition-1 |-> robotYPosition) : internal_walls) 
                THEN 
                    report := Maze_Wall_Crash
                ELSE 
                    visitedSquares := (visitedSquares <- (robotXPosition-1 |-> robotYPosition)) ||
                    currentPosition := (robotXPosition-1 |-> robotYPosition) ||
                    robotXPosition := robotXPosition-1 ||
                    report := Moved_West
                END
            END;


        report <-- Teleport(teleportXPosition, teleportYPosition) =
            PRE report : REPORT & teleportXPosition : x_axis_range & teleportYPosition : y_axis_range
            THEN
                IF (size(visitedSquares) = 1) 
                THEN 
                    report := Cannot_Teleport_Immediately
                ELSIF ((teleportXPosition |-> teleportYPosition) : internal_walls)
                THEN 
                    report := Maze_Wall_Crash
                ELSIF (teleportXPosition = robotXPosition & teleportYPosition = robotYPosition)
                THEN
                    report := Cannot_Teleport_To_The_Same_Square
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
            PRE enquiry : ENQUIRY
            THEN
                IF (currentPosition : exit_square)
                THEN 
                    enquiry := yes
                ELSE 
                    enquiry := no
                END
            END;


        visited <-- visitedSquare(visitedXPosition, visitedYPosition) =
            PRE visitedXPosition : x_axis_range & visitedYPosition : y_axis_range
            THEN 
                IF ((visitedXPosition |-> visitedYPosition) : ran(front(visitedSquares)))
                THEN 
                    visited := yes
                ELSE
                    visited := no
                END
            END;


        route <-- robotsRoute =
            BEGIN
                route := visitedSquares
            END
    
END
