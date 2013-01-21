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
    SPQuad* background;
}

- (id) initLevel:(NSUInteger)level withFrame:(CGRect)frame {
    _level = level;
    if (self = [super init:frame]) {
        //[self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (void) setup {
    
    background = [[SPQuad alloc] initWithWidth:self.size.width height:self.size.height];
    background.alpha = 0.7f;
    [background setColor:LLRand(0xFFFFFF) ofVertex:0];
    [background setColor:LLRand(0xFFFFFF) ofVertex:1];
    [background setColor:LLRand(0xFFFFFF) ofVertex:2];
    [background setColor:LLRand(0xFFFFFF) ofVertex:3];
    
    [self addChild:background];
    
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
    levelName.rotation = LL45Rad;
    [self addChild:levelName];
    
    NSArray* kittens = @[
      [[LLKitten alloc] init:rect(100, 350, 35, 35)],
      [[LLKitten alloc] init:rect(250, 400, 30, 30)]
    ];
    
    [kittens enumerateObjectsUsingBlock:^(LLKitten* kitten, NSUInteger idx, BOOL *stop) {
        [self addChild:kitten];
        kitten.constraints = (CGRect) { CGPointZero, self.size };
    }];
    
}

- (SPQuad*) quad:(CGRect)rect rotation:(CGFloat)radians pivot:(CGPoint)pivot color:(uint)color alpha:(CGFloat)alpha{
    SPQuad* quad = [[SPQuad alloc] initWithWidth:rect.size.width height:rect.size.height];
    quad.pivotX = pivot.x;
    quad.pivotY = pivot.y;
    quad.x = rect.origin.x;
    quad.y = rect.origin.y;
    quad.color = color;
    quad.alpha = alpha;
    quad.rotation = radians;
    return quad;
}

- (void) see {
        
    NSArray* models = self.models;
    [models enumerateObjectsUsingBlock:^(LLModel* seer, NSUInteger idx, BOOL *stop) {
        [models enumerateObjectsUsingBlock:^(LLModel* target, NSUInteger idx, BOOL *stop) {
            if (seer != target) {
                for (int i = -LL23Deg; i < LL23Deg; i += LL5Deg) {
                    CGLine sight = [seer sight:rad(i)];
                    
                    SPQuad* line = [[SPQuad alloc] initWithWidth:1.0f height:CGLineDistance(sight)];
                    line.color = 0x05E977;
                    line.alpha = 0.1f;
                    line.pivotX = line.width / 2.0f;
                    line.pivotY = line.height;
                    line.rotation = seer.rotation + rad(i);
                    line.x = seer.x;
                    line.y = seer.y;
                    [self addChild:line];
                    [self tween:line property:@"alpha" value:0.0f duration:0.2f];

                    if (CGLineIntersectsRect(sight, target.bounds)) {
                        SPQuad* line = [[SPQuad alloc] initWithWidth:2.0f height:CGLineDistance(sight)];
                        line.color = 0x05E9FF;
                        line.alpha = 0.2f;
                        line.pivotX = line.width / 2.0f;
                        line.pivotY = line.height;
                        line.rotation = seer.rotation + rad(i);
                        line.x = seer.x;
                        line.y = seer.y;
                        [self addChild:line];

                        SPQuad* shooter = [[SPQuad alloc] initWithWidth:target.width height:target.height];
                        shooter.color = 0xFBEC5D;
                        shooter.alpha = 0.2f;
                        shooter.pivotX = seer.pivotX;
                        shooter.pivotY = seer.pivotY;
                        shooter.rotation = seer.rotation;
                        shooter.x = seer.x;
                        shooter.y = seer.y;
                        [self addChild:shooter];
                        
                        SPQuad* hit = [[SPQuad alloc] initWithWidth:target.width height:target.height];
                        hit.color = 0xFF4500;
                        hit.alpha = 0.2f;
                        hit.pivotX = target.pivotX;
                        hit.pivotY = target.pivotY;
                        hit.rotation = target.rotation;
                        hit.x = target.x;
                        hit.y = target.y;
                        [self addChild:hit];
                        
                        
                        [self tween:shooter property:@"alpha" value:0.0f duration:1.0f];
                        [self tween:line property:@"alpha" value:0.0f duration:1.25f];
                        [self tween:hit property:@"alpha" value:0.0f duration:1.5f];
                        
                    }                    
                }
            }
        }];
        
    }];
        
}

- (void) onTick:(SPEnterFrameEvent*)event {
    [super onTick:event];
    
    NSArray* models = self.models;
    
    for (int i = 0; i < models.count; i++) {
        LLModel* model = models[i];
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
        [[self models] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (LLRandPercent < 0.35) {
                LLKitten* kitten = (LLKitten*)obj;
                CGFloat tx = LLRand(self.size.width);
                CGFloat ty = LLRand(self.size.height);
                CGPoint target = pt(tx, ty);
                //xxx adjust accel based on x/y where ever this happens
                kitten.coords.x.acceleration = LLRand(70);
                kitten.coords.y.acceleration = kitten.coords.x.acceleration;
                kitten.target = target;
            }
        }];
    }
    
    
    [self see];
        
}

//- (void)onTouch:(SPTouchEvent*)event
//{
//    NSArray *touches = [[event touchesWithTarget:self] allObjects];
//    [touches enumerateObjectsUsingBlock:^(SPTouch* touch, NSUInteger idx, BOOL *stop) {
//        SPPoint *current = [SPPoint pointWithX:touch.globalX y:touch.globalY];
//        SPPoint *previous = [SPPoint pointWithX:touch.previousGlobalX y:touch.previousGlobalY];
//        
//        NSString* phase;
//        switch (touch.phase) {
//            case SPTouchPhaseBegan: {
//                phase = @"BEGIN";
//                break;
//            }
//            case SPTouchPhaseMoved:
//                phase = @"MOVE";
////                self.position = pt(self.position.x + (current.x - previous.x), self.position.y + (current.y - previous.y));
//                break;
//            case SPTouchPhaseStationary:
//                phase = @"STILL";
//                break;
//            case SPTouchPhaseEnded: {
//                phase = @"END";
//                break;                
//            }
//            case SPTouchPhaseCancelled:
//                phase = @"CANCEL";
//                break;
//        }
//
//        
//        //NSLog(@"Touch %d from (%.1f, %.1f) to (%.1f, %.1f) [%@]", idx, previous.x, previous.y, current.x, current.y, phase);
//    }];    
//}
//

@end
