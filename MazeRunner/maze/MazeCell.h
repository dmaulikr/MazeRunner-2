//
//  MazeCell.h
//  Maze
//
//  Created by Mia Vermeir on 28/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
@import Foundation;

#import "Cell.h"

@interface MazeCell : Cell {
	BOOL leftWall ;
	BOOL rightWall ;
	BOOL upWall ;
	BOOL downWall ;
	
	BOOL visited ;
	BOOL hasPointer ;
	
	BOOL leftBorder ;
	BOOL rightBorder ;
	BOOL upBorder ;
	BOOL downBorder ;

}

+ (id) fullCell ; 
- (void) erectAllWalls ;

-	(BOOL) leftWall ;
-	(BOOL) rightWall ;
-	(BOOL) upWall ;
-	(BOOL) downWall ;

-	(void) leftWall: (BOOL) b ;
-	(void) rightWall: (BOOL) b ;
-	(void) upWall: (BOOL) b ;
-	(void) downWall: (BOOL) b ;

- (BOOL) visited ;
- (void) visited: (BOOL) b ;

- (BOOL) hasPointer ;
- (void) hasPointer: (BOOL) b ;


@end
