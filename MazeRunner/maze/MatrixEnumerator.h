//
//  MatrixEnumerator.h
//  Matrices
//
//  Created by Mia Vermeir on 23/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@import Foundation;
#import <Foundation/NSArray.h>
#import "Matrix.h"

#define BYROW 0
#define BYCOLUMN 1

@interface MatrixEnumerator : NSEnumerator {
	
	int i ;
	int j ;
	BOOL traversalOrder ;
	
	Matrix  *m ;

}

+ (id) newWithMatrix: (Matrix *) myMatrix  ;
 

- (void) setTraversalOrder: (BOOL) order ; 
- (id) init: (Matrix *) myMatrix ;
 
@end
