#import "Cell.h"


// simple implementation of a cell on a gaming board
// can later be extended to hold more complex objects (f.e. checkers)
// currently just holds his coordinates and the fact that it's empty or not

@implementation Cell

+ (id) newX: (int) x newY: (int) y isEmpty: (BOOL) b
{
	Cell *instance ;	
	instance = [Cell new] ;
	[instance x: x] ;
	[instance y: y] ;
	[instance empty: b] ;
	
	return instance ;
		
	
}

+ (id) newX: (int) x newY: (int) y isEmpty: (BOOL) b color: (UIColor *) c
{
	Cell *instance ;	
	instance = [self newX: x newY: y isEmpty:b ] ;
    instance.color = c;	
	return instance ;
	
	
}


- (void) empty: (BOOL) b
{
	empty = b ;
}

- (int) x 
{
	return x ;
}

- (void) x: (int) i 
{
	x = i ;
}

- (int) y 
{
	return y ;
}

- (void) y: (int) i
{
	y = i ;	
}

- (NSString *) UTF8String 
{
	
	return [[NSString alloc] init] ;
}

- (BOOL) isEmpty
{
	return (empty == YES) ;
}

- (BOOL) isNotEmpty
{
	return (empty == NO) ;
}
@end
