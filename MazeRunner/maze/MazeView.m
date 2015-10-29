//
//  MazeView.m
//  Maze
//
//  Created by Mia Vermeir on 28/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MazeView.h"
#import "MazeCell.h"

#define CELLSIZE 10

@implementation MazeView

- (void) setMatrix: (Matrix *) myMatrix 
{
	m = myMatrix ;	
}

//this view will handle the keystrokes
- (BOOL)acceptsFirstResponder {
    return YES;
}


- (void) controller: (id) aController
{
    controller = aController ;	
}

- (id) controller 
{
    return controller ;	
}

- (BOOL) isGenerating
{
	return isGenerating ;
}

- (void) isGenerating: (BOOL) b
{
	isGenerating = b ;
	
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	[self isGenerating: NO] ;
	
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code here.
	//NSRectFill( [self bounds] ) ;
	
 
	int x1 ;
	int x2 ;
	int offsetX = CELLSIZE;
	int offsetY = CELLSIZE;
	NSEnumerator *enumerator ;
	
    MazeCell *cell ;
	UIBezierPath* drawingPath = [UIBezierPath bezierPath];
	
	enumerator = [m objectEnumerator] ;
	
//	while ( ( cell = [enumerator nextObject] ) != nil )
//		
//	{
//		 
//		x1 = [cell x] * offsetX ;
//		x2 = [cell y] * offsetY;
//		
//		if ( [cell downWall ] )
//		{
//
//			[drawingPath moveToPoint:CGPointMake(x1,x2)];
//			
//			[drawingPath lineToPoint:CGPointMake(x1 + CELLSIZE , x2)];
//		}
//		
//		if ( [cell leftWall ] )
//		{
//			
//			
//			[drawingPath moveToPoint:CGPointMake(x1,x2)];
//			
//			
//			[drawingPath lineToPoint:NSMakePoint(x1 , x2 + CELLSIZE  )];
//		}
//		
//		
//		if ( [cell upWall ] )
//		{
//			
//			[drawingPath moveToPoint:NSMakePoint(x1,x2 + CELLSIZE)];
//			
//			
//			[drawingPath lineToPoint:NSMakePoint(x1 + CELLSIZE, x2 + CELLSIZE)];
//		}
//		
//		if ( [cell rightWall ] )
//		{
//			
//			[drawingPath moveToPoint:NSMakePoint(x1 + CELLSIZE,x2)];
//			
//			[drawingPath lineToPoint:NSMakePoint(x1 + CELLSIZE, x2 + CELLSIZE )];
//			
//		}
//		
//		 if ( ! [self isGenerating] && [cell visited] )
//		{
//			NSBezierPath *circlePath = [NSBezierPath bezierPath];;
//			
//		    [[NSColor lightGrayColor ] set ] ;	
//			[circlePath appendBezierPathWithOvalInRect:  NSMakeRect(x1   ,x2 ,CELLSIZE - 2, CELLSIZE - 2 )] ;
//			[circlePath fill] ;
//			[[NSColor blackColor] set] ;
//		}
//		 		if ( [cell hasPointer] )
//		{
//			NSBezierPath *circlePath = [NSBezierPath bezierPath];;
//			
//		    [[NSColor redColor ] set ] ;	
//			[circlePath appendBezierPathWithOvalInRect:  NSMakeRect(x1,x2 ,CELLSIZE - 2 , CELLSIZE - 2) ] ;
//			[circlePath fill] ;
//			[[NSColor blackColor] set] ;
//		}
//		
//	 
//		
//	}
//	[drawingPath stroke];
	
	
}


@end
