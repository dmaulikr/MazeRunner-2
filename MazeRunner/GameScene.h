//
//  GameScene.h
//  MazeRunner
//

//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MazeDifficultyEasy = 10,
    MazeDifficultyMedium = 15,
    MazeDifficultyHard = 20,
} MazeDifficulty;


@interface GameScene : SKScene


+ (GameScene *)sceneWithFrame:(CGSize)size difficulty:(MazeDifficulty)difficulty;


@end
