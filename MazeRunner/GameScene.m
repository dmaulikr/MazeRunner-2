//
//  GameScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameScene.h"
#import "DEMazeGenerator.h"

static const uint32_t ballBitMask     =  0x1 << 0;
static const uint32_t trapBitMask     =  0x1 << 1;
static const uint32_t exitBitMask     =  0x1 << 2;
static const uint32_t groundBitMask     =  0x1 << 3;


@import CoreMotion;
@interface GameScene ()<SKPhysicsContactDelegate>
@property(strong)SKShapeNode *ball;
@property(strong)CMMotionManager *motionManager;
@property(strong)NSOperationQueue *queue;
@property (assign, nonatomic) CMAcceleration acceleration;
@end


@implementation GameScene


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -5.0f);
        [self.physicsBody setCategoryBitMask:groundBitMask];
        [self.physicsBody setCollisionBitMask:ballBitMask];
        
        
        
//        SKShapeNode *node = [self ballWithFrame:CGRectMake(0, 200, 20, 20)];
//        [self addChild:node];
//
//        SKShapeNode *wall = [self wallWithFrame:CGRectMake(0, 0, 50, 50)];
//        [self addChild:wall];
        
        [self createMaze];
        [self setupMotion];
    }
    return self;
}


- (SKShapeNode *)ballWithFrame:(CGRect)frame
{
    int radious = (frame.size.width+frame.size.height) / 4;
    
    SKShapeNode *ball= [SKShapeNode node];
    
    ball.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)].CGPath;
    ball.position = frame.origin;
    [(SKShapeNode*)ball setFillColor:[SKColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
    ball.strokeColor = [SKColor blackColor];
    [ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:radious center:CGPointMake(radious, radious)]];
//    [ball.physicsBody setMass:10];
    ball.physicsBody.categoryBitMask =  ballBitMask;
    ball.physicsBody.contactTestBitMask = groundBitMask;
    
    return ball;
}

- (SKShapeNode *)exitWithFrame:(CGRect)frame
{
    SKShapeNode *exit=[SKShapeNode node];
    
    exit.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, frame.size.width, frame.size.height)].CGPath;
    [exit setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:exit.path]];
    [(SKShapeNode*)exit setFillColor:[SKColor colorWithRed:0 green:1 blue:0 alpha:1.0]];
    [exit.physicsBody setAffectedByGravity:NO];
    [exit.physicsBody setMass:1000];
    exit.physicsBody.categoryBitMask = exitBitMask;
    exit.physicsBody.contactTestBitMask = ballBitMask;
//    exit.fillColor = [SKColor clearColor];
//    exit.strokeColor =[SKColor blackColor];
    exit.position = frame.origin;
    
    return exit;
}

- (SKShapeNode *)wallWithFrame:(CGRect)frame
{
    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:frame];
    [node setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:node.path]];
//    [node.physicsBody setMass:1000];
    [node.physicsBody setAffectedByGravity:NO];
    [node.physicsBody setCategoryBitMask:groundBitMask];
    [node.physicsBody setContactTestBitMask:ballBitMask];
    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
    return node;
}

- (void)createMaze
{
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
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
        
        for (int r = 0; r < row * 2 + 1 ; r++)
        {
            
            for (int c = 0; c < col * 2 + 1 ; c++)
            {
                
                if (item[r][c] == 1) {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                    SKShapeNode *wall = [self wallWithFrame:rect];
                    [self addChild:wall];
                }
                else if(r == 1 && c ==1)
                {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height-2, itemSize.height-2);
                    
                    SKShapeNode *ball = [self ballWithFrame:rect];
                    [self addChild:ball];
                }
                else if (r == (row*2)-1 && c == (col*2)-1)
                {
                    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                    SKShapeNode *exit = [self exitWithFrame:rect];
                    [self addChild:exit];
                }
                
                
                
//                [rowString appendFormat:@"%@ ", item[r][c] == 1 ? @"*" : @" "];
            }
            
//            NSLog(@"%@", rowString);
        }
        
    }];
}

-(void)setupMotion{
    self.queue = [[NSOperationQueue alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                            toQueue:self.queue
                                                        withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             CGFloat x = motion.gravity.x;
             CGFloat y = motion.gravity.y;
             self.physicsWorld.gravity = CGVectorMake(y, -x);
             
         }];
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

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    /* Called when a touch begins */
////    
////    for (UITouch *touch in touches) {
////        CGPoint location = [touch locationInNode:self];
////        
////        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
////        
////        sprite.xScale = 0.5;
////        sprite.yScale = 0.5;
////        sprite.position = location;
////        
////        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
////        
////        [sprite runAction:[SKAction repeatActionForever:action]];
////        
////        [self addChild:sprite];
////    }
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        NSLog(@"%@",NSStringFromCGPoint(location));
//    }
//
////    CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), 10, 10);
////    NSLog(@"%@",NSStringFromCGRect(rect));
////    SKShapeNode *node = [SKShapeNode shapeNodeWithRect:rect];
////    [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
////    [self addChild:node];
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == trapBitMask))
    {
        NSLog(@"death!");
        
//        [self runAction:[SKAction playSoundFileNamed:@"dead.wav" waitForCompletion:YES]];
//        
//        GameOverScene *scene=[GameOverScene sceneWithSize:self.size];
//        [scene setMessage:@"You are dead!"];
//        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
        
        
        
        
    }
    else if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == exitBitMask)){
        NSLog(@"finished");
//        [[User currentUser]nextLevel];
//        LevelFinishScene *scene=[LevelFinishScene sceneWithSize:self.size];
//        [scene setMessage:@"Next Level"];
//        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
    }
    else if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == groundBitMask)){
//        [self runAction:[SKAction playSoundFileNamed:@"rolling.mp3" waitForCompletion:NO]];
    }
}
@end
