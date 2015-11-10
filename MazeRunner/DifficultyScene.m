//
//  DifficultyScene.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 09/11/15.
//  Copyright © 2015 cekisakurek. All rights reserved.
//

#import "DifficultyScene.h"
#import "GameScene.h"
#import "Constants.h"
@interface DifficultyScene ()
@property SKLabelNode *easyLabel;
@property SKLabelNode *mediumLabel;
@property SKLabelNode *hardLabel;
@end

@implementation DifficultyScene


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        _easyLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_easyLabel setText:NSLocalizedString(@"Easy", nil)];
        [_easyLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) + 70)];
        [self addChild: _easyLabel];

        _mediumLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_mediumLabel setText:NSLocalizedString(@"Medium", nil)];
        [_mediumLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        [self addChild: _mediumLabel];
        
        _hardLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NAME];
        [_hardLabel setText:NSLocalizedString(@"Hard", nil)];
        [_hardLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 70)];
        [self addChild: _hardLabel];
        
        
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([_easyLabel containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            GameScene *gameScene = [GameScene sceneWithFrame:self.size difficulty:MazeDifficultyEasy];
            [self.scene.view presentScene: gameScene transition:present];
            
        }
        else if ([_mediumLabel containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            GameScene *gameScene = [GameScene sceneWithFrame:self.size difficulty:MazeDifficultyMedium];
            [self.scene.view presentScene: gameScene transition:present];
            
        }
        else if ([_hardLabel containsPoint:location]) {
            SKTransition* present = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            GameScene *gameScene = [GameScene sceneWithFrame:self.size difficulty:MazeDifficultyHard];
            [self.scene.view presentScene: gameScene transition:present];
            
        }
    }
}

@end
