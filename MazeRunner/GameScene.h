//
//  GameScene.h
//  MazeRunner
//

//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MazeDifficultyHard = 10,
    MazeDifficultyMedium = 20,
    MazeDifficultyEasy = 32,
} MazeDifficulty;

@interface GameScene : SKScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty;

- (void)pauseGame;
- (void)resumeGame;

@end
