@interface LLMedia : NSObject 

+ (void)initAtlas;
+ (void)releaseAtlas;

+ (SPTexture *)atlasTexture:(NSString *)name;
+ (NSArray *)atlasTexturesWithPrefix:(NSString *)prefix;

+ (void)initSound;
+ (void)releaseSound;

+ (SPSoundChannel *)soundChannel:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName;

@end
