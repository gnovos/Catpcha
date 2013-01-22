//
//  LLModel.m
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#define LLDEFAULT_VISON 200.0f

#import "LLModel.h"

@implementation LLModel

- (id) init:(CGRect)bounds  {
    return [self init:bounds touchable:YES];
}

- (id) init:(CGRect)bounds touchable:(BOOL)touchable {
    
    if (self = [super init]) {
        _degrees = [[LLCurve alloc] init];
        _coords = [[LLVector alloc] init];
        _rescale = [[LLVector alloc] init:pt(1.0f, 1.0f)];
        _chroma = [[LLColor alloc] init];

        self.deg = LL0Deg;
        _degrees.acceleration = LL180Deg;
        
        _size = bounds.size;
        _center = pt(self.size.width / 2.0f, self.size.height / 2.0f);
        _vision = LLDEFAULT_VISON;
                
        self.pivotX = self.center.x;
        self.pivotY = self.center.y;
        self.x = bounds.origin.x;
        self.y = bounds.origin.y;
        self.position = bounds.origin;
        
        [self setup];
        [self addEventListener:@selector(onTick:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        if (touchable) {
            [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        }

    }
    return self;
}

- (void) dealloc {
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) setup {
}

- (void) reclaim:(SPEvent*)event {
    SPTween* tween = (SPTween*)event.target;    
    [self removeChild:tween.target];
}

- (void) tween:(NSString*)property value:(CGFloat)value duration:(CGFloat)time {
    [self tween:self property:property value:value duration:time delay:0.0f];
}

- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time {
    [self tween:target property:property value:value duration:time delay:0.0f];
}

- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time delay:(CGFloat)delay {
    SPTween *tween = [SPTween tweenWithTarget:target time:time transition:SP_TRANSITION_EASE_IN_OUT];
    [tween setDelay:delay];
    [tween animateProperty:property targetValue:value];
    [tween addEventListener:@selector(reclaim:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [self.stage.juggler addObject:tween];
}

- (CGPoint) position { return _coords.position; }
- (void) setPosition:(CGPoint)position { _coords.position = position; }

- (CGPoint) target { return _coords.target; }
- (void) setTarget:(CGPoint)target { _coords.target = target; }

- (CGFloat) rad { return rad(self.deg); }
- (void) setRad:(CGFloat)radians { self.deg = deg(radians); }

- (CGFloat) deg { return self.degrees.value; }
- (void) setDeg:(CGFloat)degrees { self.degrees.value = degrees; }

- (CGFloat) heading { return self.degrees.target; }
- (void) setHeading:(CGFloat)degrees { self.degrees.target = degrees; }

- (CGFloat) scale {
    CGPoint value = _rescale.position;
    return (value.x + value.y) / 2.0f;
}
- (void) setScale:(CGFloat)scale { _rescale.position = pt(scale, scale); }

- (CGFloat) growth {
    CGPoint value = _rescale.target;
    return (value.x + value.y) / 2.0f;
}
- (void) setGrowth:(CGFloat)growth { _rescale.target = pt(growth, growth); }

- (CGRect) bounds {
    CGPoint pos = self.position;
    pos.x -= self.pivotX;
    pos.y -= self.pivotY;
    return rect(pos.x, pos.y, self.size.width, self.size.height);
}

- (CGLine) sight {
    return [self sight:LL0Rad];
}

- (CGLine) sight:(CGFloat)radians {
    return linec(self.position, self.rotation + radians, self.vision);
}

- (void) reflect {
    LLCurve* x = _coords.x;
    LLCurve* y = _coords.y;
    
    if (CGRectGetMinX(self.bounds) < CGRectGetMinX(self.constraints)) {
        CGFloat dx = CGRectGetMinX(self.constraints) - CGRectGetMinX(self.bounds);
        [x setValue:(x.value + dx) reset:NO];
    } else if (CGRectGetMaxX(self.bounds) > CGRectGetMaxX(self.constraints)) {
        CGFloat dx = CGRectGetMaxX(self.bounds) - CGRectGetMaxX(self.constraints);
        [x setValue:(x.value - dx) reset:NO];
    }
    
    if (CGRectGetMinY(self.bounds) < CGRectGetMinY(self.constraints)) {
        CGFloat dy = CGRectGetMinY(self.constraints) - CGRectGetMinY(self.bounds);
        [y setValue:(y.value + dy) reset:NO];
    } else if (CGRectGetMaxY(self.bounds) > CGRectGetMaxY(self.constraints)) {
        CGFloat dy = CGRectGetMaxY(self.bounds) - CGRectGetMaxY(self.constraints);
        [y setValue:(y.value - dy) reset:NO];
    }
}

- (void) tickMove:(double)dt {
    if (!self.touch) {
        [_coords tick:dt];        
    }
    
    if (self.x != self.position.x) {
        [self tween:@"x" value:self.position.x duration:dt];
    }
    
    if (self.y != self.position.y) {
        [self tween:@"y" value:self.position.y duration:dt];
    }
    
    if (!CGRectIsEmpty(self.constraints) && !CGRectContainsRect(self.constraints, self.bounds)) {
        [self reflect];
    }
}

- (void) tickTurn:(double)dt {
    if (!CGPointEqualToPoint(self.position, self.target)) {
        CGFloat degrees =  CGPointDeg(self.position, self.target);
        if (ABS(self.deg - degrees) > LL180Deg) {
            //xxx check for spins
            CGFloat offset = LL180Deg + (LL180Deg - ABS(degrees));
            degrees = degrees < 0 ? offset : -offset;
        }
        
        self.heading = degrees;
    }
    
    [_degrees tick:dt];
    
    if (self.rotation != self.rad) {
        [self tween:@"rotation" value:self.rad duration:dt];
    }
    
    while (self.deg > LL180Deg) {
        self.deg -= LL360Deg;
    }
    
    while (self.deg < -LL180Deg) {
        self.deg += LL360Deg;
    }
    
}

- (void) tickGrow:(double)dt {
    [_rescale tick:dt];
    
    if (self.scaleX != self.scale) {
        [self tween:@"scaleX" value:self.scale duration:dt];
    }
    
    if (self.scaleY != self.scale) {
        [self tween:@"scaleY" value:self.scale duration:dt];
    }
    
    //xxx scale should adjust size/bounds too?
}

- (void) onTick:(SPEnterFrameEvent*)event {
    double dt = event.passedTime;
    
    [self tickMove:dt];
    
    [self tickTurn:dt];
        
    [self tickGrow:dt];
    
    [_chroma tick:dt];
}

- (NSArray*) children {
    NSMutableArray* children = [[NSMutableArray alloc] initWithCapacity:self.numChildren];
    for (int i = 0; i < self.numChildren; i++) {
        [children addObject:[self childAtIndex:i]];
    }
    return children;
}

- (NSArray*) models {
    NSMutableArray* children = [[NSMutableArray alloc] initWithCapacity:self.numChildren];
    for (int i = 0; i < self.numChildren; i++) {
        id child = [self childAtIndex:i];
        if ([child isKindOfClass:[LLModel class]]) {
            [children addObject:[self childAtIndex:i]];            
        }
    }
    return children;
}

- (NSArray*) uitouches {
    NSMutableArray* touches = [[NSMutableArray alloc] init];
    [self.models enumerateObjectsUsingBlock:^(LLModel* model, NSUInteger idx, BOOL *stop) {
        if (model.touch) {
            [touches addObject:model.touch.uiTouch];
        }
    }];
    return touches;
}

- (void) onTouch:(SPTouchEvent*)event {
    NSArray *touches = [[event touchesWithTarget:self] allObjects];
    [touches enumerateObjectsUsingBlock:^(SPTouch* touch, NSUInteger idx, BOOL *stop) {
        SPPoint *current = [touch locationInSpace:self.parent];
        SPPoint *previous = [touch previousLocationInSpace:self.parent];
        
        NSString* phase;
        switch (touch.phase) {
            case SPTouchPhaseBegan: {
                phase = @"BEGIN";
                _touch = touch;
                self.position = pt(current.x, current.y);
                break;
            }
            case SPTouchPhaseMoved:
                phase = @"MOVE";
                self.position = pt(current.x, current.y);
                break;
            case SPTouchPhaseStationary:
                phase = @"STILL";
                break;
            case SPTouchPhaseEnded: {
                self.position = pt(current.x, current.y);
                phase = @"END";
                _touch = nil;
                break;
            }
            case SPTouchPhaseCancelled:
                phase = @"CANCEL";
                _touch = nil;
                break;
        }
        
        
        NSLog(@"[%@] Touch %d from (%.1f, %.1f) to (%.1f, %.1f) [%@]",
              NSStringFromClass(self.class),
              idx, previous.x, previous.y, current.x, current.y, phase);
    }];    
}

- (SPDisplayObject*)hitTestPoint:(SPPoint*)localPoint forTouch:(BOOL)isTouch {
    SPDisplayObject* hit = [super hitTestPoint:localPoint forTouch:isTouch];
    
    if (hit && ![hit isKindOfClass:LLModel.class]) {
        return self;
    }
    
    return hit;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"[%@] loc:%@ size:%@",
            NSStringFromClass(self.class), NSStringFromCGPoint(self.position), NSStringFromCGSize(self.size)];
}

@end
