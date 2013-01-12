//
//  LLModel.m
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#import "LLModel.h"

@implementation LLModel 

- (id) init:(CGRect)bounds {
    if (self = [super init]) {
        _dynamics = [[LLDynamics alloc] init];
        _size = bounds.size;
        _center = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f);
                
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

- (CGPoint) position {
    return CGPointMake(self.dynamics.position.x.value, self.dynamics.position.y.value);
}

- (void) setPosition:(CGPoint)position {
    self.dynamics.location = position;
}

- (void) setTarget:(CGPoint)position {
    self.dynamics.target = position;
}

- (CGRect) bounds {
    return (CGRect) { self.position, self.size };
}

- (void) onTick:(SPEnterFrameEvent*)event {
    [self.dynamics tick:event.passedTime];
    
    self.x = self.dynamics.position.x.value;
    self.y = self.dynamics.position.y.value;
    self.rotation = self.dynamics.angle.value;
    self.scaleX = self.dynamics.scale.x.value;
    self.scaleY = self.dynamics.scale.y.value;
    //xxx scale should adjust size, or use some other size thing?
    
    if (!CGRectIsEmpty(self.constraints) && !CGRectContainsRect(self.constraints, self.bounds)) {
        dlogobj(self);
        dlogrect(self.bounds);
        dlogrect(self.constraints);
        dlog(@"%d %d", CGRectIsEmpty(self.constraints), CGRectContainsRect(self.constraints, self.bounds));
    }
}

- (NSArray*) children {
    NSMutableArray* children = [[NSMutableArray alloc] initWithCapacity:self.numChildren];
    for (int i = 0; i < self.numChildren; i++) {
        [children addObject:[self childAtIndex:i]];
    }
    return children;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"loc:%@ size:%@", NSStringFromCGPoint(self.position), NSStringFromCGSize(self.size)];
}

@end
