
#import "LLViewController.h"

@implementation LLViewController

- (id) init {

    if (self = [super init]) {
        _app = [UIApplication sharedApplication].delegate;
    }
    
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    NSArray* orientations = self.app.orientations;
    
    return ((orientation == UIInterfaceOrientationPortrait && [orientations containsObject:@"UIInterfaceOrientationPortrait"])
            || (orientation == UIInterfaceOrientationLandscapeLeft && [orientations containsObject:@"UIInterfaceOrientationLandscapeLeft"])
            || (orientation == UIInterfaceOrientationPortraitUpsideDown && [orientations containsObject:@"UIInterfaceOrientationPortraitUpsideDown"])
            || (orientation == UIInterfaceOrientationLandscapeRight && [orientations containsObject:@"UIInterfaceOrientationLandscapeRight"]));
}

- (NSUInteger) supportedInterfaceOrientations {
    NSArray* orientations = self.app.orientations;
    
    NSUInteger supported = 0;
    if ([orientations containsObject:@"UIInterfaceOrientationPortrait"]) {
        supported |= UIInterfaceOrientationMaskPortrait;
    }
    
    if ([orientations containsObject:@"UIInterfaceOrientationLandscapeLeft"]) {
        supported |= UIInterfaceOrientationMaskLandscapeLeft;
    }
    
    if ([orientations containsObject:@"UIInterfaceOrientationPortraitUpsideDown"]) {
        supported |= UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    
    if ([orientations containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        supported |= UIInterfaceOrientationMaskLandscapeRight;
    }
    
    return supported;
}


@end
