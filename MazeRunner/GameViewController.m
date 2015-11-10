//
//  GameViewController.m
//  MazeRunner
//
//  Created by Cihan Emre Kisakurek (Company) on 28/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "GameViewController.h"
#import "SplashScene.h"

@implementation GameViewController


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.multipleTouchEnabled = YES;

    if (!skView.scene) {
#if DEBUG
        skView.showsFPS = YES;
        skView.showsDrawCount = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics=YES;
#endif
        
        //        skView.ignoresSiblingOrder = YES;
        //        skView.frameInterval = 2;
        //        skView.shouldCullNonVisibleNodes = NO;
        
        
        // Create and configure the scene.
        SKScene * scene = [SplashScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
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
