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

- (id) init:(CGRect)bounds {
    if (self = [super init]) {
        _dynamics = [[LLDynamics alloc] init];
        _size = bounds.size;
        _center = pt(self.size.width / 2.0f, self.size.height / 2.0f);
        _vision = LLDEFAULT_VISON;
                
        self.pivotX = self.center.x;
        self.pivotY = self.center.y;
        self.x = bounds.origin.x;
        self.y = bounds.origin.y;
        self.dynamics.location = bounds.origin;
        
        [self setup];
        [self addEventListener:@selector(onTick:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
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

- (CGPoint) position {
    return pt(self.dynamics.position.x.value, self.dynamics.position.y.value);
}

- (void) setPosition:(CGPoint)position {
    self.dynamics.location = position;
}

- (CGPoint) target {
    return pt(self.dynamics.position.x.target, self.dynamics.position.y.target);
}

- (void) setTarget:(CGPoint)position {
    self.dynamics.target = position;
}

- (CGRect) bounds {
    CGPoint pos = self.position;
    pos.x -= self.pivotX;
    pos.y -= self.pivotY;
    return rect(pos.x, pos.y, self.size.width, self.size.height);
}

- (CGLine) sight {
    return CGLineCalc(self.position, self.rotation, self.vision);
}

- (void) reflect {
    if (CGRectGetMinX(self.bounds) < CGRectGetMinX(self.constraints)) {
        self.dynamics.position.x.adjust += CGRectGetMinX(self.constraints) - CGRectGetMinX(self.bounds);
    } else if (CGRectGetMaxX(self.bounds) > CGRectGetMaxX(self.constraints)) {
        self.dynamics.position.x.adjust -= CGRectGetMaxX(self.bounds) - CGRectGetMaxX(self.constraints);
    }
    
    if (CGRectGetMinY(self.bounds) < CGRectGetMinY(self.constraints)) {
        self.dynamics.position.y.adjust += CGRectGetMinY(self.constraints) - CGRectGetMinY(self.bounds);
    } else if (CGRectGetMaxY(self.bounds) > CGRectGetMaxY(self.constraints)) {
        self.dynamics.position.y.adjust -= CGRectGetMaxY(self.bounds) - CGRectGetMaxY(self.constraints);
    }
}

- (void) onTick:(SPEnterFrameEvent*)event {
    if (!CGPointEqualToPoint(self.position, self.target)) {
        CGFloat angle = deg(CGPointAngle(self.position, self.target));
        CGFloat da = angle - self.dynamics.angle.value;
        if (ABS(da) > 180) {
            angle = angle - 360;
        }
        
        //xxx check rotation for spins?
        self.dynamics.angle.acceleration = 135;
        self.dynamics.angle.target = angle;
    }
    
    
    [self.dynamics tick:event.passedTime];
    
    [self tween:@"x" value:self.dynamics.position.x.value duration:event.passedTime];
    [self tween:@"y" value:self.dynamics.position.y.value duration:event.passedTime];
    [self tween:@"rotation" value:rad(self.dynamics.angle.value) duration:event.passedTime];
    
//    self.x = self.dynamics.position.x.value;
//    self.y = self.dynamics.position.y.value;
//    self.rotation = rad(self.dynamics.angle.value);
    
    //xxx adjust rotation for negativeness?
    
    self.scaleX = self.dynamics.scale.x.value;
    self.scaleY = self.dynamics.scale.y.value;
    //xxx scale should adjust size, or use some other size thing?
    
    if (!CGRectIsEmpty(self.constraints) && !CGRectContainsRect(self.constraints, self.bounds)) {
        [self reflect];
    }
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

- (NSString*) description {
    return [NSString stringWithFormat:@"loc:%@ size:%@", NSStringFromCGPoint(self.position), NSStringFromCGSize(self.size)];
}

@end
