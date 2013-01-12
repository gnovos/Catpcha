//
//  LLevel.m
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#import "LLevel.h"
#import "LLKitten.h"

@implementation LLevel {
    
}

- (id) initLevel:(NSUInteger)level withBounds:(CGRect)bounds {
    _level = level;
    if (self = [super init:bounds]) {
        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (void) setup {
    
    SPQuad* bg = [[SPQuad alloc] initWithWidth:self.size.width height:self.size.height];
    [bg setColor:0x992233 ofVertex:0];
    [bg setColor:0x99FF33 ofVertex:1];
    [bg setColor:0x9922FF ofVertex:2];
    [bg setColor:0xFF2233 ofVertex:3];
    
    [self addChild:bg];
    
    NSString *text = [NSString stringWithFormat:@"LEVEL %d", self.level];
    
    SPTextField *levelName = [[SPTextField alloc] initWithWidth:self.size.width
                                                         height:self.size.height
                                                           text:text
                                                       fontName:@"ArialRoundedMTBold"
                                                       fontSize:78.0f
                                                          color:0x123456];
    levelName.pivotX = levelName.width / 2.0f;
    levelName.pivotY = levelName.height / 2.0f;
    levelName.alpha = 0.4f;
    levelName.x = self.center.x;
    levelName.y = self.center.y;
    levelName.rotation = SP_D2R(45);
    [self addChild:levelName];
    
    NSArray* kittens = @[
      [[LLKitten alloc] init:CGRectMake(30, 100, 50, 50)],
      [[LLKitten alloc] init:CGRectMake(100, 300, 50, 50)],
      [[LLKitten alloc] init:CGRectMake(200, 300, 10, 10)],
      [[LLKitten alloc] init:CGRectMake(250, 300, 25, 25)]
    ];
    
    [kittens enumerateObjectsUsingBlock:^(LLKitten* kitten, NSUInteger idx, BOOL *stop) {
        [self addChild:kitten];
        kitten.target = CGPointMake(kitten.position.x, idx % 2 == 0 ? 100 : 500);
        kitten.dynamics.position.y.acceleration = 20.0f * (idx + 1);
        kitten.constraints = (CGRect) { CGPointZero, self.size };
    }];
    
    [((LLKitten*)[kittens lastObject]) setTarget:CGPointMake(250, -10)];
        
}

- (void) onTick:(SPEnterFrameEvent*)event {
    [super onTick:event];
    [self.children enumerateObjectsUsingBlock:^(id child, NSUInteger idx, BOOL *stop) {
        if ([child isKindOfClass:[LLModel class]]) {
            [child onTick:event];
        }
    }];    
}

- (void)onTouch:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self] allObjects];
    [touches enumerateObjectsUsingBlock:^(SPTouch* touch, NSUInteger idx, BOOL *stop) {
        SPPoint *current = [SPPoint pointWithX:touch.globalX y:touch.globalY];
        SPPoint *previous = [SPPoint pointWithX:touch.previousGlobalX y:touch.previousGlobalY];
        
        NSString* phase;
        switch (touch.phase) {
            case SPTouchPhaseBegan:
                phase = @"BEGIN";
                break;
            case SPTouchPhaseMoved:
                phase = @"MOVE";
                self.position = CGPointMake(self.position.x + (current.x - previous.x), self.position.y + (current.y - previous.y));
                break;
            case SPTouchPhaseStationary:
                phase = @"STILL";
                break;
            case SPTouchPhaseEnded: {
                phase = @"END";
                break;                
            }
            case SPTouchPhaseCancelled:
                phase = @"CANCEL";
                break;
        }

        
        NSLog(@"Touch %d from (%.1f, %.1f) to (%.1f, %.1f) [%@]", idx, previous.x, previous.y, current.x, current.y, phase);
    }];    
}


@end
