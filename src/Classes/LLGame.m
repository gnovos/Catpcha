#import <OpenGLES/ES1/gl.h>
#import "LLGame.h"

#import "LLevel.h"

@implementation LLGame

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super initWithWidth:width height:height])) {
        [self setup];
        
        CGRect lbounds = rect(0, 0, width * 1.0f, height * 1.0f);
        dlogrect(lbounds);
                
        LLevel* level = [[LLevel alloc] initLevel:1 withBounds:lbounds];
        dlogobj(level);
        level.position = pt(width / 2.0f, height / 2.0f);
        
        [self addChild:level];        
    }
    
    return self;
}

- (void)dealloc
{
    // release any resources here
    
    [LLMedia releaseAtlas];
    [LLMedia releaseSound];
    
}

- (void)setup
{
    // This is where the code of your game will start.
    // In this sample, we add just a few simple elements to get a feeling about how it's done.
    
    [SPAudioEngine start];  // starts up the sound engine
    
    
    // The Application contains a very handy "Media" class which loads your texture atlas
    // and all available sound files automatically. Extend this class as you need it --
    // that way, you will be able to access your textures and sounds throughout your
    // application, without duplicating any resources.
    
    [LLMedia initAtlas];      // loads your texture atlas -> see Media.h/Media.m
    [LLMedia initSound];      // loads all your sounds    -> see Media.h/Media.m
    
}


@end
