//
//  MazeCell.m
//  Maze
//
//  Created by Mia Vermeir on 28/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MazeCell.h"


@implementation MazeCell

+ (id) fullCell
{
	MazeCell *instance ;
	instance = [self new] ;
	[instance erectAllWalls] ;
	return instance ;
}

- (id) init 
{
    self = [super init];
    if (self)
    {
        leftWall = NO ;
        rightWall = NO ;
        upWall = NO ;
        downWall = NO ;
        visited = NO ;
        hasPointer = NO ;
        
    }
	
	return self ;
}
- (void) erectAllWalls 
{
	 
	leftWall = YES ;
	rightWall = YES ;
	upWall = YES ;
	downWall = YES ;
	visited = NO ;
	hasPointer = NO ;
	 
}

-	(BOOL) leftWall
{
	return leftWall ;
}

-	(BOOL) rightWall
{
	return rightWall ;
}
-	(BOOL) upWall
{
	return upWall ;
}
-	(BOOL) downWall 
{
	return downWall ;
}

-	(BOOL) visited 
{
	return visited ;
}
-	(void) leftWall: (BOOL) b 
{
	  leftWall = b ;
}

-	(void) rightWall: (BOOL) b 
{
	  rightWall = b ;
}
-	(void) upWall: (BOOL) b 
{
	  upWall = b ;
}

-	(void) downWall: (BOOL) b 
{
	  downWall = b;
}

-	(void) visited: (BOOL) b 
{
	visited = b;
}

-	(void) hasPointer: (BOOL) b 
{
	hasPointer = b;
}

-	(BOOL) hasPointer 
{
	return hasPointer ;
}

- (unsigned ) hash
{
	return random() ;	
}

@end
