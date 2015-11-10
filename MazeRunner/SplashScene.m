//
//  SplashScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 09/11/15.
//  Copyright © 2015 cekisakurek. All rights reserved.
//

#import "SplashScene.h"
#import "DifficultyScene.h"
#import "Constants.h"

@interface SplashScene ()
@property SKLabelNode *playNode;
@property SKLabelNode *settingsNode;

@property SKLabelNode *helpNode;
@end

@implementation SplashScene


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        _playNode = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_playNode setText:NSLocalizedString(@"Play", nil)];
        [_playNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 70)];
        [self addChild: _playNode];
        
        _helpNode = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_helpNode setText:NSLocalizedString(@"Help", nil)];
        [_helpNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        [self addChild: _helpNode];
        
        _settingsNode = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_settingsNode setText:NSLocalizedString(@"Settings", nil)];
        [_settingsNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 70)];
        [self addChild: _settingsNode];
        
        
    }
    return self;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([_playNode containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            DifficultyScene* difficultyScene = [[DifficultyScene alloc] initWithSize:self.size];
            [self.scene.view presentScene: difficultyScene transition:present];
            
        }
        else if ([_helpNode containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            DifficultyScene* difficultyScene = [[DifficultyScene alloc] initWithSize:self.size];
            [self.scene.view presentScene: difficultyScene transition:present];
            
        }
        else if ([_settingsNode containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            DifficultyScene* difficultyScene = [[DifficultyScene alloc] initWithSize:self.size];
            [self.scene.view presentScene: difficultyScene transition:present];
            
        }
    }
}

@end
