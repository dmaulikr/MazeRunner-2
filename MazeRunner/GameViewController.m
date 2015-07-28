//
//  GameViewController.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"



@implementation GameViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    /* Sprite Kit applies additional optimizations to improve rendering performance */
//    skView.ignoresSiblingOrder = YES;
//    
//    // Create and configure the scene.
//    GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsPhysics=YES;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [GameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
