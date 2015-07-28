//
//  GameScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameScene.h"
#import "DEMazeGenerator.h"
@import CoreMotion;

static const uint32_t ballBitMask       =  0x1 << 0;
//static const uint32_t trapBitMask       =  0x1 << 1;
static const uint32_t exitBitMask       =  0x1 << 2;
static const uint32_t groundBitMask     =  0x1 << 3;

@interface GameScene ()<SKPhysicsContactDelegate>

@property (assign)MazeDifficulty difficulty;
@property(strong)SKShapeNode *ball;
@property(strong)CMMotionManager *motionManager;
@property(strong)NSOperationQueue *queue;
@property (assign, nonatomic) CMAcceleration acceleration;

@end

@implementation GameScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty
{
    GameScene *scene = [[GameScene alloc] initWithSize:size];
    scene.difficulty = difficulty;
    return scene;
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0f, -5.0f);
        
//        self.backgroundColor = [SKColor whiteColor];
        
//        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
//        [self.physicsBody setCategoryBitMask:groundBitMask];
//        [self.physicsBody setCollisionBitMask:ballBitMask];

//        SKShapeNode *node = [self ballWithFrame:CGRectMake(0, 200, 20, 20)];
//        [self addChild:node];
//
//        SKShapeNode *wall = [self wallWithFrame:CGRectMake(0, 0, 50, 50)];
//        [self addChild:wall];
        
        [self createMazeWithDifficulty:self.difficulty];
        [self setupMotion];
    }
    return self;
}

- (void)createMazeWithDifficulty:(int)difficulty
{
    CGSize mazeSize = CGSizeMake(self.size.height/2.0, self.size.width/2.0);
    
    if (difficulty > 20) {
        difficulty = 20;
    }

    CGSize itemSize = CGSizeMake(30-difficulty, 30-difficulty);
    int row = floorf(mazeSize.height / itemSize.height);
    int col = floorf(mazeSize.width / itemSize.width);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSMutableArray *bodies = [NSMutableArray array];
        CGMutablePathRef path = CGPathCreateMutable();
        
        DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:row andCol:col withStartingPoint:DEIntegerPointMake(1, 1)];
        [maze arrayMaze:^(bool **item)
        {
            for (int r = 0; r < row * 2 + 1 ; r++)
            {
                for (int c = 0; c < col * 2 + 1 ; c++)
                {
                    if (item[r][c] == 1)
                    {
                        CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                        [bodies addObject:[SKPhysicsBody bodyWithEdgeLoopFromRect:rect]];
                        CGPathAddRect(path, NULL, rect);
                    }
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            //Run UI Updates
            //create maze
            SKEffectNode *effectNode = [[SKEffectNode alloc]init];
            SKShapeNode  *shape = [[SKShapeNode alloc] init];
            shape.path = path;
            [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
            
            [effectNode addChild:shape];
            [self addChild:effectNode];
            
            effectNode.shouldRasterize = YES;
            
            //create ball
            {
                CGRect rect = CGRectMake((1*itemSize.width), (1*itemSize.height), itemSize.height-5, itemSize.height-5);
                SKShapeNode *ball = [self ballWithFrame:rect];
                [self addChild:ball];
            }
            //create exit
            {
                CGRect rect = CGRectMake(((((row*2))-1)*itemSize.width), (((col*2)-1)*itemSize.height), itemSize.height, itemSize.height);
                SKShapeNode *exit = [self exitWithFrame:rect];
                [self addChild:exit];
            }
            
            self.physicsBody = [SKPhysicsBody bodyWithBodies:bodies];
            [self.physicsBody setCategoryBitMask:groundBitMask];
            [self.physicsBody setCollisionBitMask:ballBitMask];
            self.physicsBody.affectedByGravity = NO;
        });
    });
}

- (void)setupMotion
{
    self.queue = [[NSOperationQueue alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
    
    __weak GameScene *weakRef = self;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                            toQueue:self.queue
                                                        withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             CGFloat x = motion.gravity.x;
             CGFloat y = motion.gravity.y;
             weakRef.physicsWorld.gravity = CGVectorMake(y, -x);
             
         }];
     }];
}

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
//    if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == trapBitMask))
//    {
//        NSLog(@"death!");
//        
////        [self runAction:[SKAction playSoundFileNamed:@"dead.wav" waitForCompletion:YES]];
////        
////        GameOverScene *scene=[GameOverScene sceneWithSize:self.size];
////        [scene setMessage:@"You are dead!"];
////        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
//        
//        
//        
//        
//    }
    if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == exitBitMask)){
        GameScene *scene = [GameScene sceneWithFrame:self.size difficulty:MazeDifficultyHard];
        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
    }
//    else if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == groundBitMask)){
////        [self runAction:[SKAction playSoundFileNamed:@"rolling.mp3" waitForCompletion:NO]];
//    }
}













- (SKShapeNode *)ballWithFrame:(CGRect)frame
{
    int radius = (frame.size.width+frame.size.height) / 4;
    SKShapeNode *ball= [SKShapeNode node];
    ball.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)].CGPath;
    ball.position = frame.origin;
    [(SKShapeNode*)ball setFillColor:[SKColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
    ball.strokeColor = [SKColor blackColor];
    [ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:radius center:CGPointMake(radius, radius)]];
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
    exit.position = frame.origin;
    
    return exit;
}
@end
