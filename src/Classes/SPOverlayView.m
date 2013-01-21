#import "SPOverlayView.h"

@implementation SPOverlayView

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    __block BOOL hit = NO;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        CGPoint innerPoint = pt(point.x - view.frame.origin.x, point.y - view.frame.origin.y);
        if ([view pointInside:innerPoint withEvent:event]) {
            hit = YES;
            *stop = YES;
        }
    }];
    
    return hit;
}

@end
