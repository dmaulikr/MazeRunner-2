//
//  GameScene.h
//  MazeRunner
//

//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MazeDifficultyNightmare = 8,
    MazeDifficultyHardcore = 10,
    MazeDifficultyHarder = 16,
    MazeDifficultyHard = 20,
    MazeDifficultyMedium = 32,
    MazeDifficultyEasy = 40,
} MazeDifficulty;
//8 10 16 20 32 40

@interface GameScene : SKScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty;


@end
