//
//  LLDynamics.m
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

//xxx
//x&y should change in direction to heading?

#import "LLDynamics.h"

@implementation LLDynamics

- (id) init {
    if (self = [super init]) {
        _angle = [[LLCurve alloc] init];
        _position = [[LLVector alloc] init];
        _scale = [[LLVector alloc] init:pt(1.0f, 1.0f)];
        _color = [[LLColor alloc] init];
    }
    return self;
}

- (void) setLocation:(CGPoint)position {
    _position.position = position;
}

- (void) setTarget:(CGPoint)target {
    _position.target = target;
}

- (void) setRotation:(CGFloat)angle {
    _angle.value = angle;
}

- (void) setHeading:(CGFloat)target {
    _angle.target = target;
}

- (void) setScaleValue:(CGPoint)scale {
    _scale.position = scale;
}

- (void) setScaleTarget:(CGPoint)target {
    _scale.target = target;
}

- (void) setColorValue:(LLRGBA)color {
    _color.color = color;
}

- (void) setColorTarget:(LLRGBA)target {
    _color.target = target;
}

- (void) tick:(CGFloat)dt {
    [self.angle tick:dt];
    [self.position tick:dt];
    [self.scale tick:dt];
    [self.color tick:dt];
}

- (NSString*) description {
    return [NSString stringWithFormat:@" ->angle) %@\n ->pos) %@\n ->scale) %@\n ->color) %@\\n\n",
            self.angle, self.position, self.scale, self.color];
}


@end
