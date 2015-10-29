//
//  MatrixOutofBoundException.m
//  GameOfLife
//
//  Created by Mia Vermeir on 14/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixOutofBoundException.h"


@implementation MatrixOutofBoundException

+ raise 
{
    [[super exceptionWithName:@"Matrix out of bound exception" reason: @"Matrix out bounds exception : out of bounds" userInfo: nil] raise] ;
	return self ;
}

@end
