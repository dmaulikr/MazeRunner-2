//
//  GameScene1.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 29/10/15.
//  Copyright © 2015 cekisakurek. All rights reserved.
//

#import "GameScene1.h"
#import "MazeCell.h"
#define MAZE_WIDTH 40
#define MAZE_HEIGHT 40
#define CELLSIZE 10
@implementation GameScene1

+ (GameScene1 *)sceneWithFrame:(CGSize)size
{
    GameScene1 *scene = [[GameScene1 alloc] initWithSize:size];
    return scene;
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        
        self.maze = [Matrix newWithXRows:MAZE_WIDTH YRows: MAZE_HEIGHT];
        
        
        self.abbas = [[SKCameraNode alloc] init];
        
        self.camera = self.abbas;
        
        
        [self buildMaze];
        [self drawMaze];
        
        
    }
    return self;
}


- (void)buildMaze
{
    
    for (int x = 0 ; x < MAZE_WIDTH ; x++ )
    {
        
        for (int y = 0 ; y < MAZE_HEIGHT ; y++ )
        {
            MazeCell *cell = [MazeCell fullCell] ;
            
            [cell x: x ] ;
            [cell y: y] ;
            [self.maze atX: x atY: y put: cell] ;
            
        }
    }
    
    int x ;
    int y ;
    
    
    
    srandom((unsigned)time(NULL) ) ;
    
    x = random() % (MAZE_WIDTH - 2) + 1 ;
    y = random() % (MAZE_HEIGHT - 2) + 1 ;
    
    x = 0;
    y = 0;
    
    
    
    [self walkCells: [self.maze atX: x atY: y] ] ;
    
    [[self.maze atX: 0 atY: (MAZE_WIDTH - 1)] upWall: NO ] ;
    [[self.maze atX: 0 atY: (MAZE_HEIGHT - 1)] hasPointer: YES ] ;
    
//    pointerX = 0 ;
//    pointerY = MAZE_HEIGHT - 1;
    
    [[self.maze atX: (MAZE_WIDTH - 1) atY: 0] downWall: NO ] ;
    for ( x = 0 ; x < MAZE_WIDTH ; x++ )
    {
        
        for ( y = 0 ; y < MAZE_HEIGHT ; y++ )
        {
            
            [[self.maze atX: x atY: y ] visited: NO]  ;
            
        }
    }
    
//    [mazeview isGenerating: NO] ;
//    [mazeview setMatrix: maze] ;
//    [mazeview  setNeedsDisplay: YES] ;

}

- (void)drawMaze
{
    int x1 ;
    int x2 ;
    int offsetX = CELLSIZE;
    int offsetY = CELLSIZE;
    NSEnumerator *enumerator ;
    
    MazeCell *cell ;
    
    UIBezierPath* drawingPath = [UIBezierPath bezierPath];
    
    enumerator = [self.maze objectEnumerator] ;
    int b = 0;
    while ( ( cell = [enumerator nextObject] ) != nil )
        
    {
        
        if (b == 10) {
            break;
        }
        
        x1 = [cell x] * offsetX ;
        x2 = [cell y] * offsetY;
        
        if ( [cell downWall ] )
        {
         

            [drawingPath moveToPoint:CGPointMake(x1,x2)];
            [drawingPath addLineToPoint:CGPointMake(x1 + CELLSIZE , x2)];
        }
        
        if ( [cell leftWall ] )
        {
            
            
            [drawingPath moveToPoint:CGPointMake(x1,x2)];
            
            
            [drawingPath addLineToPoint:CGPointMake(x1 , x2 + CELLSIZE  )];
        }
        
        
        if ( [cell upWall ] )
        {
            
            [drawingPath moveToPoint:CGPointMake(x1,x2 + CELLSIZE)];
            
            
            [drawingPath addLineToPoint:CGPointMake(x1 + CELLSIZE, x2 + CELLSIZE)];
        }
        
        if ( [cell rightWall ] )
        {
            
            [drawingPath moveToPoint:CGPointMake(x1 + CELLSIZE,x2)];
            
            [drawingPath addLineToPoint:CGPointMake(x1 + CELLSIZE, x2 + CELLSIZE )];
            
        }
        
//        if ( ! [self isGenerating] && [cell visited] )
//        {
//            NSBezierPath *circlePath = [NSBezierPath bezierPath];;
//            
//            [[NSColor lightGrayColor ] set ] ;
//            [circlePath appendBezierPathWithOvalInRect:  NSMakeRect(x1   ,x2 ,CELLSIZE - 2, CELLSIZE - 2 )] ;
//            [circlePath fill] ;
//            [[NSColor blackColor] set] ;
//        }
//        if ( [cell hasPointer] )
//        {
//            NSBezierPath *circlePath = [NSBezierPath bezierPath];;
//            
//            [[NSColor redColor ] set ] ;	
//            [circlePath appendBezierPathWithOvalInRect:  NSMakeRect(x1,x2 ,CELLSIZE - 2 , CELLSIZE - 2) ] ;
//            [circlePath fill] ;
//            [[NSColor blackColor] set] ;
//        }
        
        
        
    }
    
//    SKEffectNode *effectNode = [[SKEffectNode alloc]init];
    SKShapeNode  *shape = [SKShapeNode node];
    shape.path = drawingPath.CGPath;
    [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
    //            [effectNode addChild:shape];
    //            [self addChild:effectNode];
    [self addChild:shape];
    
//    effectNode.shouldRasterize = YES;
//    [drawingPath stroke];
}

- (void) walkCells: (MazeCell *) aCell
{
    int x ;
    int y ;
    
    NSMutableSet *neighbors ;
    MazeCell *cell1 ;
    NSEnumerator *enumerator ;
    
    [aCell visited: YES] ;
    
    
    x = [aCell x];
    y = [aCell y];
    
    neighbors = [NSMutableSet set] ;
    if ( x > 0 ) [neighbors addObject: [self.maze atX: (x-1) atY: y ]] ;
    
    if ( y > 0 )  [neighbors addObject: [self.maze atX: (x) atY: (y-1) ]] ;
    
    if ( x < (MAZE_WIDTH - 1) ) [neighbors addObject: [self.maze atX: (x+1) atY: y ]] ;
    
    if ( y < (MAZE_HEIGHT - 1) ) [neighbors addObject: [self.maze atX: (x ) atY: (y+1) ]] ;
    
    
    enumerator = [ neighbors objectEnumerator] ;
    
    
//    usleep( 300 ) ;
    while ( (cell1 = [enumerator nextObject] ) != nil )
    {
        
        if ( [cell1 visited] == NO )
        {
            if ( [cell1 x] == (x-1) )
            {
                [cell1 rightWall: NO] ;
                [aCell leftWall: NO] ;
            }
            
            if ( [cell1 x] == (x+1) )
            {
                [aCell rightWall: NO] ;
                [cell1 leftWall: NO] ;
            }
            if ( [cell1 y] == (y-1) )
            {
                [cell1 upWall: NO] ;
                [aCell downWall: NO] ;
            }
            
            if ( [cell1 y] == (y+1) ) 
            {
                [aCell upWall: NO] ;
                [cell1 downWall: NO] ;
            }
            
            
            [self walkCells: cell1] ;
            
        }
    }
    
    
}



@end
