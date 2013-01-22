#import "LLGameViewController.h"
#import "LLGame.h"

@implementation LLGameViewController {
    LLGame* game;
    SPView* spview;
    UIRotationGestureRecognizer* rot;
    UIPanGestureRecognizer* pan;
    UIPinchGestureRecognizer* pin;
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
    
    rot = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(recognize:)];
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognize:)];
    pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognize:)];
    
    [@[rot, pan, pin] enumerateObjectsUsingBlock:^(UIGestureRecognizer* recognizer, NSUInteger idx, BOOL *stop) {
        recognizer.delegate = self;
//        recognizer.cancelsTouchesInView = NO;
//        recognizer.delaysTouchesEnded = NO;
//        recognizer.delaysTouchesBegan = NO;
        [spview addGestureRecognizer:recognizer];
    }];
        
}

- (void) onApplicationDidBecomeActive:(NSNotification*)notification { [spview start]; }
- (void) onApplicationWillResignActive:(NSNotification*)notification { [spview stop]; }

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)a shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)b { return YES; }

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)recognizer shouldReceiveTouch:(UITouch*)touch {
    if (recognizer == pan) {
        CGPoint touched = [touch locationInView:spview];
        SPPoint* point = [SPPoint pointWithX:touched.x y:touched.y];
        return game.level == [game hitTestPoint:point forTouch:YES];
    }
    return YES;
}

- (void) recognize:(id)sender {
    if (sender == pan) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            [pan setTranslation:game.level.position inView:nil];
        } else {
            CGPoint xlate = [pan translationInView:nil];
            CGPoint velocity = [pan velocityInView:nil];
            game.level.position = xlate;
        }
                
    } else if (sender == rot) {
        game.level.rad = rot.rotation;
        
    } else if (sender == pin) {
        if (pin.state == UIGestureRecognizerStateBegan) {
            pin.scale = game.level.scale;
        } else {
            game.level.scale = MAX(0.4, MIN(pin.scale, 3.0f));
        }
    }
}


@end
