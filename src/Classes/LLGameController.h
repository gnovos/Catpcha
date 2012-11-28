#import "SPStage.h"
#import "LLGame.h"

@interface LLGameController : SPStage
{
    LLGame *mGame;
}

- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                       animationTime:(double)time;

@end
