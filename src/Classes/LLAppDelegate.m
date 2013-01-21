#import "LLAppDelegate.h"
#import "LLGameViewController.h"

@implementation LLAppDelegate {
    UIWindow* window;
    LLGameViewController* root;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)options {
    window = [[UIWindow alloc] initWithFrame:self.bounds];
    
    root = [[LLGameViewController alloc] init];
    
    if ([window respondsToSelector:@selector(setRootViewController:)]) {
        [window setRootViewController:root];
    } else {
        [window addSubview:root.view];
    }

    [window makeKeyAndVisible];
    
    return YES;
}

- (NSNotificationCenter*) notifications { return [NSNotificationCenter defaultCenter]; }

- (CGRect) bounds { return [UIScreen mainScreen].bounds; }

- (NSArray*) orientations { return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"]; }

@end
