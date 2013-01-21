#import <OpenGLES/ES1/gl.h>
#import "LLGame.h"

#import "LLevel.h"

@implementation LLGame

- (id) init {
    if (self = [super init]) {
        [SPStage setSupportHighResolutions:YES];
        
        [SPAudioEngine start];
        [LLMedia initAtlas];      // loads your texture atlas -> see Media.h/Media.m
        [LLMedia initSound];      // loads all your sounds    -> see Media.h/Media.m

        CGRect frame = rect(self.width / 2.0f, self.height / 2.0f, self.width * 1.5f, self.height * 1.5f);
        _level = [[LLevel alloc] initLevel:1 withFrame:frame];
        
        [self addChild:_level];
    }
    
    return self;
}

- (void)dealloc{
    [LLMedia releaseAtlas];
    [LLMedia releaseSound];
}


@end
