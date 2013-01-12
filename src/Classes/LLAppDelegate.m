#import "LLAppDelegate.h"
#import "LLViewController.h"
#import "LLVector.h"

@implementation LLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    mWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    
    [SPStage setSupportHighResolutions:YES];
    
    SPView *sparrowView = [[SPView alloc] initWithFrame:screenBounds];
    sparrowView.multipleTouchEnabled = YES; 
    sparrowView.frameRate = 30;            // possible fps: 60, 30, 20, 15, 12, 10, etc.
    [mWindow addSubview:sparrowView];
    
    LLGame *gameController = [[LLGame alloc] init];
    sparrowView.stage = gameController;
    
    mViewController = [[LLViewController alloc] initWithSparrowView:sparrowView];
    
    if ([mWindow respondsToSelector:@selector(setRootViewController:)])
        [mWindow setRootViewController:mViewController];
    else
        [mWindow addSubview:mViewController.view];

    [mWindow makeKeyAndVisible];
    
    return YES;
}

@end
