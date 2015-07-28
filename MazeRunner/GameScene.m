//
//  GameScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameScene.h"
#import "DEMazeGenerator.h"
@implementation GameScene


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        [self createMaze];
    }
    return self;
}

- (void)createMaze
{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//    CGSize mazeSize = self.size;
    CGSize mazeSize = CGSizeMake(150, 250);
    
    CGSize itemSize = CGSizeMake(10, 10);
    
//    int row = 20;
//    int col = 20;

    int row = mazeSize.height/itemSize.height;
    int col = mazeSize.width/itemSize.width;
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:row andCol:col withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
        
//        NSMutableString *rowString = [NSMutableString string];
        
        for (int r = 0; r < row * 2 + 1 ; r++)
        {
//            [rowString setString:[NSString stringWithFormat:@"%d: ", r]];
            
            for (int c = 0; c < col * 2 + 1 ; c++)
            {
                
                
                
                
                
                if (item[r][c] == 1) {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
//                    NSLog(@"%@",NSStringFromCGRect(rect));
                    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:rect];
                    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
                    [self addChild:node];
                }
                else if(r == 1 && c ==1)
                {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                    //                    NSLog(@"%@",NSStringFromCGRect(rect));
                    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:rect];
                    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
                    [self addChild:node];
                    if (r == 1 && c == 1) {
                        [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:1 green:0.5 blue:0.5 alpha:1.0]];
                    }
                }
                else if (r == (row*2)-1 && c == (col*2)-1)
                {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                    //                    NSLog(@"%@",NSStringFromCGRect(rect));
                    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:rect];
                    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.51 green:1 blue:0.5 alpha:1.0]];
                    [self addChild:node];
                }
                
                
                
//                [rowString appendFormat:@"%@ ", item[r][c] == 1 ? @"*" : @" "];
            }
            
//            NSLog(@"%@", rowString);
        }
        
    }];
}


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"%@",NSStringFromCGPoint(location));
    }

//    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), 10, 10);
//    NSLog(@"%@",NSStringFromCGRect(rect));
//    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:rect];
//    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
//    [self addChild:node];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
