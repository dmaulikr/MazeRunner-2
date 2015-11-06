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
static const uint32_t exitBitMask       =  0x1 << 1;
static const uint32_t groundBitMask     =  0x1 << 2;


#define MAX_ZOOM_SCALE 3.0

@interface GameScene ()<SKPhysicsContactDelegate>

@property (assign)MazeDifficulty difficulty;
@property(strong)SKShapeNode *ball;
@property(strong)CMMotionManager *motionManager;
@property(strong)NSOperationQueue *queue;
@property (assign, nonatomic) CMAcceleration acceleration;

@property SKCameraNode *cevat;

@property SKNode *canvas;

@property CGFloat mazeWidth;

@property CGFloat initialScale;
@property CGPoint panStartPoint;

@property (assign)CGRect accumulatedCanvasFrame;
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
            CGPoint translation = [sender translationInView:sender.view];
            translation = CGPointMake(-translation.x, translation.y);
            
            CGPoint movePoint = CGPointMake(self.camera.position.x + translation.x * self.camera.xScale, self.camera.position.y);
            if (movePoint.x < self.size.width/2.0)
            {

                movePoint.x = self.size.width/2.0;
                SKAction *move = [SKAction moveTo:movePoint duration:0.1];
                [self.cevat runAction:move];
                
            }

            else if(movePoint.x > (self.accumulatedCanvasFrame.size.width - self.size.width/2.0))
            {
                movePoint.x = (self.accumulatedCanvasFrame.size.width - self.size.width/2.0);
                SKAction *move = [SKAction moveTo:movePoint duration:0.1];
                [self.cevat runAction:move];
            }
            else
            {
                self.cevat.position = movePoint;
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

        self.physicsWorld.contactDelegate = self;

        self.mazeWidth = 2000;

        

        self.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1];
        
        
        self.canvas = [SKNode node];
        [self addChild:self.canvas];
        
        self.cevat = [[SKCameraNode alloc] init];
        [self addChild:self.cevat];
        self.camera = self.cevat;
        
        self.camera.position = CGPointMake(size.width/2.0, size.height/2.0);
        
        [self createMazeWithDifficulty:MazeDifficultyHarder];
        [self setupMotion];
        
    }
    return self;
}

- (void)createMazeWithDifficulty:(int)difficulty
{
    self.difficulty = difficulty;
    CGSize mazeSize = CGSizeMake(self.size.height/2.0, self.mazeWidth);

    // 2 4 8 10 16 20 32 40 80/160
    // 2 4 8 16 6 12 24 48 10 20 40 80 30 60 120/240
    
    // 
    
    
    CGSize itemSize = CGSizeMake(self.difficulty, self.difficulty);
    int row = floorf(mazeSize.height / itemSize.height);
    int col = floorf(mazeSize.width / itemSize.width);
    
    //Background Thread
    
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:row andCol:col withStartingPoint:DEIntegerPointMake(1, 1)];
    [maze arrayMaze:^(bool **item)
     {
         
         
         NSMutableArray *bodies = [NSMutableArray array];
         NSMutableArray *paths = [NSMutableArray array];
         for (int r = 0; r < row * 2 + 1 ; r++)
         {
             CGMutablePathRef pathOfColumn = CGPathCreateMutable();
             NSMutableArray *bodiesOfColumn = [NSMutableArray array];
             for (int c = 0; c < col * 2 + 1 ; c++)
             {
                 if (item[r][c] == 1)
                 {
                     CGRect rect = CGRectMake((r*itemSize.width), (c*itemSize.height), itemSize.height, itemSize.height);
                     
                     CGPathAddRect(pathOfColumn, NULL, rect);
                     [bodiesOfColumn addObject:[SKPhysicsBody bodyWithEdgeLoopFromRect:rect]];
                 }
             }
             [paths addObject:(__bridge id)pathOfColumn];
             [bodies addObject:bodiesOfColumn];
             CGPathRelease(pathOfColumn);
         }
         
         
         for (int i = 0; i < paths.count; i++) {
             
             CGPathRef p = (__bridge CGPathRef)[paths objectAtIndex:i];
             NSArray *bodyArray = [bodies objectAtIndex:i];

             
             
             
             SKShapeNode  *shape = [[SKShapeNode alloc] init];
             shape.path = p;
//             [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
             [shape setStrokeColor:[SKColor lightGrayColor]];
             [shape setFillColor:[SKColor colorWithWhite:180.0/255.0 alpha:1]];
             shape.physicsBody = [SKPhysicsBody bodyWithBodies:bodyArray];
             shape.physicsBody.affectedByGravity = NO;
             shape.physicsBody.dynamic = NO;
             [self.canvas addChild:shape];
             
             
             
             
         }
         
         self.accumulatedCanvasFrame = [self.canvas calculateAccumulatedFrame];
         
         //create ball
         {
             //CGRect rect = CGRectMake((1*itemSize.width), (1*itemSize.height), itemSize.height-5, itemSize.height-5);
             CGRect rect = CGRectMake(((((row*2))-1)*itemSize.width), (((col*2)-1)*itemSize.height), itemSize.height - 5, itemSize.height - 5);
             SKShapeNode *ball = [self ballWithFrame:rect];
             [self addChild:ball];
         }
         //create exit
         {
//             CGRect rect = CGRectMake(((((row*2))-1)*itemSize.width), (((col*2)-1)*itemSize.height), itemSize.height, itemSize.height);
             CGRect rect = CGRectMake((1*itemSize.width), (1*itemSize.height), itemSize.height, itemSize.height);
             SKShapeNode *exit = [self exitWithFrame:rect];
             [self addChild:exit];
         }
     }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startingAnimation];
    });
    
}


- (void)startingAnimation
{
    SKAction *move = [SKAction moveTo:CGPointMake((self.accumulatedCanvasFrame.size.width - self.size.width/2.0), self.cevat.position.y) duration:3];
    [self.cevat runAction:move];
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
    if ((firstBody.categoryBitMask == ballBitMask) &&(secondBody.categoryBitMask == exitBitMask)){
        GameScene *scene = [GameScene sceneWithFrame:self.size difficulty:MazeDifficultyHard];
        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
    }
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
