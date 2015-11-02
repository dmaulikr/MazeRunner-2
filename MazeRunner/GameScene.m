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


#define MAX_ZOOM_SCALE 3.0

@interface GameScene ()<SKPhysicsContactDelegate>

@property (assign)MazeDifficulty difficulty;
@property(strong)SKShapeNode *ball;
@property(strong)CMMotionManager *motionManager;
@property(strong)NSOperationQueue *queue;
@property (assign, nonatomic) CMAcceleration acceleration;

@property SKCameraNode *abbas;

@property SKNode *canvas;

@property CGFloat mazeWidth;

@property CGFloat initialScale;
@property CGPoint panStartPoint;
@end

@implementation GameScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty
{
    GameScene *scene = [[GameScene alloc] initWithSize:size];
    scene.difficulty = difficulty;
    return scene;
}

- (void)pinch:(UIPinchGestureRecognizer *)sender
{

    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.initialScale = sender.scale;
            break;
        case UIGestureRecognizerStateChanged:
        {
            float dS = self.initialScale - sender.scale;
            
            self.camera.xScale += dS;
            self.camera.yScale += dS;


            if ((self.camera.xScale) < 1.0)
            {
                self.camera.xScale = 1.0;
                self.camera.yScale = 1.0;
            }
            else if((self.camera.xScale) > MAX_ZOOM_SCALE)
            {
                self.camera.xScale = MAX_ZOOM_SCALE;
                self.camera.yScale = MAX_ZOOM_SCALE;

            }
            NSLog(@"%f",self.camera.xScale);
        }
        

            break;
        default:
            break;
    }
    
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [sender locationInView:sender.view];
            self.panStartPoint =[self convertPointFromView:self.panStartPoint];
            break;
        case UIGestureRecognizerStateChanged:
        {
//            CGPoint lastPoint = [sender translationInView:sender.view];
//            float dX = (lastPoint.x - self.panStartPoint.x);
//            float dY = (lastPoint.y - self.panStartPoint.y);
//            self.camera.position = CGPointMake(self.camera.position.x - dX, self.camera.position.y + dY);
////            NSLog(@"%f %f",dX,dY);
//            NSLog(@"%@",NSStringFromCGPoint(lastPoint));
//            [sender setTranslation:CGPointZero inView:sender.view];
            
            
            CGPoint translation = [sender translationInView:sender.view];
            translation = CGPointMake(-translation.x, translation.y);
            
            CGPoint movePoint = CGPointMake(self.camera.position.x + translation.x * self.camera.xScale, self.camera.position.y);
            if (movePoint.x < self.size.width/2.0)
            {

                movePoint.x = self.size.width/2.0;
                SKAction *move = [SKAction moveTo:movePoint duration:0.1];
                [self.abbas runAction:move];
                
            }
            else if(movePoint.x > (self.mazeWidth + self.size.width))
            {
                movePoint.x = (self.mazeWidth + self.size.width);
                SKAction *move = [SKAction moveTo:movePoint duration:0.1];
                [self.abbas runAction:move];
            }
            else
            {
                self.abbas.position = movePoint;
            }
            
            [sender setTranslation:CGPointZero inView:sender.view];
            
        }
            
            
            break;
        default:
            break;
    }
}

- (void)didMoveToView:(SKView *)view
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
//        self.view.multipleTouchEnabled = YES;
        
        
//        self.initialDistance = 1;

//        self.unitDistance = [self getDistance:CGPointMake(0, 0) toPoint:CGPointMake(size.width, size.height)] / 4.0;

        self.mazeWidth = 1000;

        
        
        
        self.difficulty = MazeDifficultyEasy;
//        self.difficulty = MazeDifficultyMedium;
//        self.difficulty = MazeDifficultyHard;
//        self.difficulty = MazeDifficultyHarder;
//        self.difficulty = MazeDifficultyHardcore;
//        self.difficulty = MazeDifficultyNightmare;
        self.physicsWorld.contactDelegate = self;
//        self.physicsWorld.gravity = CGVectorMake(0.0f, -5.0f);
        
//        self.backgroundColor = [SKColor whiteColor];
        
//        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
//        [self.physicsBody setCategoryBitMask:groundBitMask];
//        [self.physicsBody setCollisionBitMask:ballBitMask];

//        SKShapeNode *node = [self ballWithFrame:CGRectMake(0, 200, 20, 20)];
//        [self addChild:node];
//
//        SKShapeNode *wall = [self wallWithFrame:CGRectMake(0, 0, 50, 50)];
//        [self addChild:wall];
        
        self.abbas = [[SKCameraNode alloc] init];
        [self addChild:self.abbas];
        self.camera = self.abbas;
        
        self.camera.position = CGPointMake(size.width/2.0, size.height/2.0);
        
        [self createMazeWithDifficulty:self.difficulty];
        [self setupMotion];
        
    }
    return self;
}

- (void)createMazeWithDifficulty:(int)difficulty
{
//    CGSize mazeSize = CGSizeMake(160*2, 240*2);
    CGSize mazeSize = CGSizeMake(self.size.height/2.0, self.mazeWidth);
    NSLog(@"size:%@",NSStringFromCGSize(mazeSize));

    
    
    

    // 2 4 8 10 16 20 32 40 80/160
    // 2 4 8 16 6 12 24 48 10 20 40 80 30 60 120/240
    
    // 
    
    
    CGSize itemSize = CGSizeMake(32, 32);
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
//                        [bodies addObject:[SKPhysicsBody bodyWithEdgeLoopFromRect:rect]];
                        CGPathAddRect(path, NULL, rect);
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void)
                                       {
                        SKShapeNode  *shape = [[SKShapeNode alloc] init];
                        shape.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
                        [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
                        //            [effectNode addChild:shape];
                        //            [self addChild:effectNode];
                                           shape.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
                        [self addChild:shape];
                                       });
                        
                    }
                }
            }
        }];
        return
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            //Run UI Updates
            //create maze
            SKEffectNode *effectNode = [[SKEffectNode alloc]init];
            SKShapeNode  *shape = [[SKShapeNode alloc] init];
            shape.path = path;
            [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
//            [effectNode addChild:shape];
//            [self addChild:effectNode];
            [self addChild:shape];
            
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
            
            
//            shape.physicsBody = [SKPhysicsBody bodyWithBodies:bodies];
//            [shape.physicsBody setCategoryBitMask:groundBitMask];
//            [shape.physicsBody setCollisionBitMask:ballBitMask];
//            shape.physicsBody.affectedByGravity = NO;
//            shape.physicsBody.dynamic = NO;
            
//            self.physicsBody = [SKPhysicsBody bodyWithBodies:bodies];
//            [self.physicsBody setCategoryBitMask:groundBitMask];
//            [self.physicsBody setCollisionBitMask:ballBitMask];
//            self.physicsBody.affectedByGravity = NO;
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (touches.count == 1) {
//        UITouch *t = [touches anyObject];
//        self.panStartPoint = [t locationInNode:self];
//    }
//    
//
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    if (touches.count == 1) {
//        UITouch *t = [touches anyObject];
//        
//        CGPoint lastPoint = [t locationInNode:self];
//
//        
//        float dX = self.panStartPoint.x - lastPoint.x;
//        float dY = self.panStartPoint.y - lastPoint.y;
//        self.camera.position = CGPointMake(self.camera.position.x + dX, self.camera.position.y + dY);
//
//    }
//   
//
//    
//    
//    
//}
//- (double)getDistance:(CGPoint)fromPoint toPoint:(CGPoint)otherPoint
//{
//    double deltaX = otherPoint.x - fromPoint.x;
//    double deltaY = otherPoint.y - fromPoint.y;
//    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
//}
@end
