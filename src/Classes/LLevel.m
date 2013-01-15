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
    [bg setColor:0x112233 ofVertex:0];
    [bg setColor:0x22FF33 ofVertex:1];
    [bg setColor:0x3322FF ofVertex:2];
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
      [[LLKitten alloc] init:CGRectMake(100, 350, 35, 35)],
      [[LLKitten alloc] init:CGRectMake(200, 300, 10, 10)],
      [[LLKitten alloc] init:CGRectMake(240, 300, 25, 25)],
      [[LLKitten alloc] init:CGRectMake(200, 360, 20, 20)],
      [[LLKitten alloc] init:CGRectMake(120, 300, 15, 15)],
      [[LLKitten alloc] init:CGRectMake(250, 300, 30, 30)]
    ];
    
    [kittens enumerateObjectsUsingBlock:^(LLKitten* kitten, NSUInteger idx, BOOL *stop) {
        [self addChild:kitten];
        kitten.constraints = (CGRect) { CGPointZero, self.size };
    }];        
}

- (NSArray*) sight:(CGLine)sight {
    NSMutableArray* seen = [[NSMutableArray alloc] init];
    
    [self.models enumerateObjectsUsingBlock:^(LLModel* obj, NSUInteger idx, BOOL *stop) {
        
    }];
    
    return seen;
}

- (void) onTick:(SPEnterFrameEvent*)event {
    [super onTick:event];
    
    NSArray* models = self.models;
    
    for (int i = 0; i < models.count; i++) {
        LLModel* model = models[i];
        CGPoint last = model.position;
        [model onTick:event];
        for (int j = i + 1; j < models.count; j++) {
            CGRect test = ((LLModel*)models[j]).bounds;
            CGRect bounds = model.bounds;
            if (CGRectIntersectsRect(bounds, test)) {
                CGPoint position = model.position;
                
                CGFloat mleft = bounds.origin.x;
                CGFloat mright = bounds.origin.x + bounds.size.width;
                CGFloat mtop = bounds.origin.y;
                CGFloat mbottom = bounds.origin.y + bounds.size.height;
                
                CGFloat tleft = test.origin.x;
                CGFloat tright = test.origin.x + test.size.width;
                CGFloat ttop = test.origin.y;
                CGFloat tbottom = test.origin.y + test.size.height;
                
                if (mright < tright && mright > tleft) {
                    position.x -= mright - tleft;
                } else if (mleft > tleft && mleft < tright) {
                    position.x += tright - mleft;
                }
                
                if (mbottom < tbottom && mbottom > ttop) {
                    position.y -= mbottom - ttop;
                } else if (mtop > ttop && mtop < tbottom) {
                    position.y += tbottom - mtop;
                }

                model.position = position;
            }
        }
    }
    
    
    static double last = 0;
    if ([[NSDate date] timeIntervalSince1970] - last > 1) {
        last = [[NSDate date] timeIntervalSince1970];
        [[self children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[LLKitten class]]) {
                if (LLRandPercent < 0.35) {
                    LLKitten* kitten = (LLKitten*)obj;
                    CGFloat tx = LLRand(self.size.width);
                    CGFloat ty = LLRand(self.size.height);
                    CGPoint target = CGPointMake(tx, ty);
                    kitten.dynamics.angle.acceleration = 180;
                    kitten.dynamics.position.x.acceleration = LLRand(70);
                    kitten.dynamics.position.y.acceleration = kitten.dynamics.position.x.acceleration;
                    kitten.target = target;
                }
            }
        }];
    }
}

- (void)onTouch:(SPTouchEvent*)event
{
    NSArray *touches = [[event touchesWithTarget:self] allObjects];
    [touches enumerateObjectsUsingBlock:^(SPTouch* touch, NSUInteger idx, BOOL *stop) {
        SPPoint *current = [SPPoint pointWithX:touch.globalX y:touch.globalY];
        SPPoint *previous = [SPPoint pointWithX:touch.previousGlobalX y:touch.previousGlobalY];
        
        NSString* phase;
        switch (touch.phase) {
            case SPTouchPhaseBegan: {
                phase = @"BEGIN";
                break;
            }
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
