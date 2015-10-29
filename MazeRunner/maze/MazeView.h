//
//  MazeView.h
//  Maze
//
//  Created by Mia Vermeir on 28/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "Matrix.h"

@interface MazeView : UIView {
	Matrix *m ;
	id controller ;
	
	BOOL isGenerating ;

}

- (void) setMatrix: (Matrix *) myMatrix ;

- (void) controller: (id) aController ;
 

- (id) controller ;
 
- (BOOL) isGenerating ;

- (void) isGenerating: (BOOL) b ;

@end
