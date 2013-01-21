#import "LLGameViewController.h"
#import "LLGame.h"

@implementation LLGameViewController {
    LLGame* game;
    SPView* spview;
}

- (void)didReceiveMemoryWarning {
    [SPPoint purgePool];
    [SPRectangle purgePool];
    [SPMatrix purgePool];
    [super didReceiveMemoryWarning];
}

- (id) init {
    if (self = [super init]) {
        game = [[LLGame alloc] init];
        
        [self.app.notifications addObserver:self
               selector:@selector(onApplicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self.app.notifications addObserver:self
               selector:@selector(onApplicationWillResignActive:)
                   name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}


- (void) loadView {
    
    [super loadView];
    spview = [[SPView alloc] initWithFrame:rect(0, 0, game.width, game.height)];
    self.view = spview;

    spview.multipleTouchEnabled = YES;
    
    spview.frameRate = 30; // possible fps: 60, 30, 20, 15, 12, 10, etc.
    spview.stage = game;
    
    NSArray* recognizers = @[[UIRotationGestureRecognizer class],
                             [UIPinchGestureRecognizer class],
                             [UIPanGestureRecognizer class]];
    
    [recognizers enumerateObjectsUsingBlock:^(Class c, NSUInteger idx, BOOL *stop) {
        UIGestureRecognizer* recognizer = [[c alloc] initWithTarget:self action:@selector(recognize:)];
        recognizer.delegate = self;
        [spview addGestureRecognizer:recognizer];
    }];
    
}

- (void) onApplicationDidBecomeActive:(NSNotification*)notification { [spview start]; }
- (void) onApplicationWillResignActive:(NSNotification*)notification { [spview stop]; }

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)a shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)b { return YES; }

- (void) recognize:(id)sender {
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer* recognizer = (UIPanGestureRecognizer*)sender;
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [recognizer setTranslation:game.level.position inView:nil];
        } else {
            CGPoint xlate = [recognizer translationInView:nil];
            CGPoint velocity = [recognizer velocityInView:nil];
            game.level.position = xlate;
        }
        
    } else if ([sender isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer* recognizer = (UIRotationGestureRecognizer*)sender;
        game.level.rad = recognizer.rotation;
        
    } else if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer* recognizer = (UIPinchGestureRecognizer*)sender;        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            recognizer.scale = game.level.scale;
        } else {
            game.level.scale = MAX(0.4, MIN(recognizer.scale, 3.0f));
        }
    }
}


@end
