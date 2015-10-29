/* Cell */

@import Foundation;
@import UIKit;

@interface Cell : NSObject
{
	int x ;
	int y ;
	BOOL empty ; 
	UIColor *color ;
	UIImage *skin ;
}

@property UIColor *color;
@property UIImage *skin;

+ (id) newX: (int) x newY: (int) y isEmpty: (BOOL) b ;
+ (id) newX: (int) x newY: (int) y isEmpty: (BOOL) b color: (UIColor *) c ;
- (int) x ;
- (void) x: (int) i ;

- (int) y ;
- (void) y: (int) i;

- (NSString *) UTF8String ;

- (void) empty: (BOOL) b ;
- (BOOL) isEmpty ;
- (BOOL) isNotEmpty ;


@end
