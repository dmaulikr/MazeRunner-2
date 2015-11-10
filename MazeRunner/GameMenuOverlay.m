//
//  InGameMenuOverlay.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 09/11/15.
//  Copyright © 2015 cekisakurek. All rights reserved.
//

#import "GameMenuOverlay.h"
#import "SplashScene.h"
#import "Constants.h"

@interface GameMenuOverlay ()
@property (strong) GameScene *gameScene;
@property SKLabelNode *infoLabel;
@property SKLabelNode *timeLabel;
@property SKLabelNode *resumeLabel;
@property SKLabelNode *quitLabel;
@end

@implementation GameMenuOverlay

+ (instancetype)overlayWithGameScene:(GameScene *)gameScene
{
    GameMenuOverlay *overlay = [[GameMenuOverlay alloc] initWithSize:gameScene.size];
    overlay.gameScene = gameScene;
    return overlay;
}


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        _infoLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_infoLabel setText:NSLocalizedString(@"Game is paused!", nil)];
        [_infoLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 50)];
        [self addChild: _infoLabel];
        
        _timeLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_timeLabel setText:NSLocalizedString(@"00:00", nil)];
        [_timeLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        [self addChild: _timeLabel];
        
        
        _resumeLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_resumeLabel setText:NSLocalizedString(@"Resume", nil)];
        [_resumeLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 50)];
        [self addChild: _resumeLabel];
        
        _quitLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_quitLabel setText:NSLocalizedString(@"Quit", nil)];
        [_quitLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 100)];
        [self addChild: _quitLabel];
        
        
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([_quitLabel containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.5];
            SplashScene *scene = [SplashScene sceneWithSize:self.size];
            [self.scene.view presentScene: scene transition:present];
            
        }
        else if ([_resumeLabel containsPoint:location])
        {
            [self.gameScene resumeGame];
            [self.scene.view presentScene:self.gameScene];
        }
    }
}




@end
