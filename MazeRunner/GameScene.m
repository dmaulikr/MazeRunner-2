//
//  GameScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameScene.h"
#import "DEMazeGenerator.h"
#import "GameMenuOverlay.h"
@import CoreMotion;

static const uint32_t ballBitMask       =  0x1 << 0;
static const uint32_t exitBitMask       =  0x1 << 1;
static const uint32_t groundBitMask     =  0x1 << 2;


#define MAX_ZOOM_SCALE 3.0
#define MIN_ZOOM_SCALE 1.0

@interface GameScene ()<SKPhysicsContactDelegate>

@property (assign,nonatomic)MazeDifficulty difficulty;
@property(strong)SKShapeNode *ball;
@property(strong)CMMotionManager *motionManager;
@property(strong)NSOperationQueue *queue;
@property (assign, nonatomic) CMAcceleration acceleration;

@property SKCameraNode *cevat;

@property SKNode *canvas;
@property SKLabelNode *timeLabel;
@property CGFloat mazeWidth;

@property CGFloat initialScale;

@property NSTimeInterval startTime;

@property (assign)CGRect accumulatedCanvasFrame;


@property UIPinchGestureRecognizer *pinchRecognizer;
@property UIPanGestureRecognizer *panRecognizer;
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation GameScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty
{
    GameScene *scene = [[GameScene alloc] initWithSize:size];
    scene.difficulty = difficulty;
    return scene;
}

- (void)didMoveToView:(SKView *)view
{
    
    [self.view addGestureRecognizer:self.pinchRecognizer];
    
    
    [self.view addGestureRecognizer:self.panRecognizer];
    
    
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {

        
        self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        self.physicsWorld.contactDelegate = self;

        self.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1];
        
        
        self.canvas = [SKNode node];
        [self addChild:self.canvas];
        
        self.cevat = [[SKCameraNode alloc] init];
        [self addChild:self.cevat];
        self.camera = self.cevat;
        
        self.camera.position = CGPointMake(size.width/2.0, size.height/2.0);
        
        _difficulty = MazeDifficultyEasy;
        [self setupMotion];
        
    }
    return self;
}


- (void)setDifficulty:(MazeDifficulty)difficulty
{
    
    _difficulty = difficulty;
    
    switch (_difficulty) {
        case MazeDifficultyEasy:
        {
            NSNumber *w = [[NSUserDefaults standardUserDefaults] valueForKey:@"Easy-Width"];
            if (!w) {
                w = @(self.size.width);
            }
            self.mazeWidth = [w floatValue];
        }
            
            break;
        case MazeDifficultyMedium:
        {
            NSNumber *w = [[NSUserDefaults standardUserDefaults] valueForKey:@"Medium-Width"];
            if (!w) {
                w = @(self.size.width);
            }
            self.mazeWidth = [w floatValue];
        }
            break;
        case MazeDifficultyHard:
        {
            NSNumber *w = [[NSUserDefaults standardUserDefaults] valueForKey:@"Hard-Width"];
            if (!w) {
                w = @(self.size.width);
            }
            self.mazeWidth = [w floatValue];
        }
            break;
        default:
            self.mazeWidth = self.size.width;
            break;
    }
    
    [self createMazeWithDifficulty:_difficulty];
}

- (void)createMazeWithDifficulty:(int)difficulty
{
    //Background Thread
    __weak GameScene *weakRef = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        CGSize mazeSize = CGSizeMake(weakRef.size.height/2.0, weakRef.mazeWidth);
        
        CGSize itemSize = CGSizeMake(weakRef.difficulty, weakRef.difficulty);
        int row = floorf(mazeSize.height / itemSize.height);
        int col = floorf(mazeSize.width / itemSize.width);
        

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
                         
                         [bodiesOfColumn addObject:[SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(rect.origin.x, rect.origin.y, itemSize.height, itemSize.width)]];
                     }
                 }
                 CGPathCloseSubpath(pathOfColumn);
                 [paths addObject:(__bridge id)pathOfColumn];
                 [bodies addObject:bodiesOfColumn];
                 CGPathRelease(pathOfColumn);
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakRef drawMazeWithPaths:paths bodies:bodies row:row col:col itemSize:itemSize];
             });
             
             
         }];

        
        
        
    });
    
}

- (void)drawMazeWithPaths:(NSArray *)paths bodies:(NSArray *)bodies row:(NSUInteger)row col:(NSUInteger)col itemSize:(CGSize)itemSize
{
    
    for (int i = 0; i < paths.count; i++) {
        
        CGPathRef p = (__bridge CGPathRef)[paths objectAtIndex:i];
        NSArray *bodyArray = [bodies objectAtIndex:i];
        SKShapeNode  *shape = [[SKShapeNode alloc] init];
        shape.blendMode = SKBlendModeReplace;
        shape.path = p;
        //             [(SKShapeNode*)shape setFillColor:[SKColor colorWithRed:0.5 green:0.5 blue:1 alpha:1.0]];
        [shape setStrokeColor:[SKColor clearColor]];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startingAnimation];
    });
}


- (void)startingAnimation
{
    SKAction *move = [SKAction moveTo:CGPointMake((self.accumulatedCanvasFrame.size.width - self.size.width/2.0), self.cevat.position.y) duration:3];
    __weak GameScene *weakRef = self;
    SKAction *startTimer = [SKAction runBlock:^{
        weakRef.startTime = [NSDate timeIntervalSinceReferenceDate];
    }];
    [self.cevat runAction:[SKAction sequence:@[move,startTimer]]];
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
        
        
        switch (self.difficulty) {
            case MazeDifficultyEasy:
                [[NSUserDefaults standardUserDefaults] setValue:@(self.mazeWidth * 1.2) forKey:@"Easy-Width"];
                break;
            case MazeDifficultyMedium:
                [[NSUserDefaults standardUserDefaults] setValue:@(self.mazeWidth * 1.2) forKey:@"Medium-Width"];
                break;
            case MazeDifficultyHard:
                [[NSUserDefaults standardUserDefaults] setValue:@(self.mazeWidth * 1.2) forKey:@"Hard-Width"];
                break;
            default:
                break;
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GameScene *scene = [GameScene sceneWithFrame:self.size difficulty:self.difficulty];
        [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1]];
    }
}



- (SKShapeNode *)ballWithFrame:(CGRect)frame
{
    int radius = (frame.size.width+frame.size.height) / 4;
    SKShapeNode *ball= [SKShapeNode node];
    ball.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)].CGPath;
    ball.position = frame.origin;
    [(SKShapeNode*)ball setFillColor:[SKColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    ball.strokeColor = [SKColor clearColor];

    [ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:radius center:CGPointMake(frame.size.width/2.0, frame.size.width/2.0)]];
    ball.physicsBody.categoryBitMask =  ballBitMask;
    ball.physicsBody.contactTestBitMask = groundBitMask;
    
    return ball;
}

- (SKShapeNode *)exitWithFrame:(CGRect)frame
{
    SKShapeNode *exit=[SKShapeNode node];
    exit.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, frame.size.width, frame.size.height)].CGPath;
    [exit setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:exit.path]];
    [(SKShapeNode*)exit setFillColor:[SKColor colorWithRed:1 green:0.2 blue:0.2 alpha:0.8]];
    [exit.physicsBody setAffectedByGravity:NO];
    [exit.physicsBody setMass:1000];
    exit.physicsBody.categoryBitMask = exitBitMask;
    exit.physicsBody.contactTestBitMask = ballBitMask;
    exit.position = frame.origin;
    
    return exit;
}

#pragma mark - Camera Functions
- (void)moveCameraToPoint:(CGPoint)point
{
    if (point.x < self.size.width/2.0)
    {
        point.x = self.size.width/2.0;
        SKAction *move = [SKAction moveTo:point duration:0.1];
        [self.cevat runAction:move];
    }
    
    else if(point.x > (self.accumulatedCanvasFrame.size.width - self.size.width/2.0))
    {
        point.x = (self.accumulatedCanvasFrame.size.width - self.size.width/2.0);
        SKAction *move = [SKAction moveTo:point duration:0.1];
        [self.cevat runAction:move];
    }
    else
    {
        self.cevat.position = point;
    }
}

- (void)zoomCameraToScale:(CGFloat)scale
{
    self.camera.xScale = scale;
    self.camera.yScale = scale;
    
    
    if ((self.camera.xScale) < MIN_ZOOM_SCALE)
    {
        self.camera.xScale = MIN_ZOOM_SCALE;
        self.camera.yScale = MIN_ZOOM_SCALE;
    }
    else if((self.camera.xScale) > MAX_ZOOM_SCALE)
    {
        self.camera.xScale = MAX_ZOOM_SCALE;
        self.camera.yScale = MAX_ZOOM_SCALE;
        
    }
}

#pragma mark - Gestures
- (void)pinch:(UIPinchGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.initialScale = sender.scale;
            break;
        case UIGestureRecognizerStateChanged:
        {
            float dS = self.initialScale - sender.scale;
            CGFloat calculatedScale = self.camera.xScale + dS;
            [self zoomCameraToScale:calculatedScale];
        }
            break;
        default:
            break;
    }
    
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [sender translationInView:sender.view];
            translation = CGPointMake(-translation.x, translation.y);
            
            CGPoint movePoint = CGPointMake(self.camera.position.x + translation.x * self.camera.xScale, self.camera.position.y);
            [self moveCameraToPoint:movePoint];
            [sender setTranslation:CGPointZero inView:sender.view];
        }
            break;
        default:
            break;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (!self.paused)
    {
        [self pauseGame];
        GameMenuOverlay *overlay = [GameMenuOverlay overlayWithGameScene:self];
        [self.view presentScene:overlay];
    }

}

- (void)pauseGame
{
    self.panRecognizer.enabled = NO;
    self.tapRecognizer.enabled = NO;
    self.pinchRecognizer.enabled = NO;
    self.paused = YES;
}

- (void)resumeGame
{
    self.panRecognizer.enabled = YES;
    self.tapRecognizer.enabled = YES;
    self.pinchRecognizer.enabled = YES;
    self.paused = NO;
}

@end
