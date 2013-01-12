//
//  LLMoment.m
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

#import "LLCurve.h"

@implementation LLCurve {
    CGFloat _initial;
    CGFloat _peak;
    CGFloat _velocity;
    int _direction;
}

- (id) init {
    return [self init:0.0f];
}

- (id) init:(CGFloat)initial {
    if (self = [super init]) {
        self.value = initial;
        _acceleration = 1.0f;
        _peak = 0.5f;
        _direction = 0;
    }
    return self;
}

- (void) direct {
    if (_target > _initial) {
        _direction = 1;
    } else if (_target < _initial) {
        _direction = -1;
    } else {
       _direction = 0;
    }
}

- (void) setTarget:(CGFloat)target {
    _initial = _value;
    _target = target;
    [self direct];
}

- (void) setValue:(CGFloat)value {
    _value = value;
    _initial = value;
    _target = value;
    _velocity = 0.0f;
}

- (CGFloat) progress {
    CGFloat total = ABS(_target - _initial);
    CGFloat delta = ABS(_target - _value);
    return total ? 1.0f - (delta / total) : 1.0f;
}

- (CGFloat) jolt {
    return (_peak - [self progress]) / _peak;
}

- (CGFloat) speed {
    return _acceleration * [self jolt];
}

- (BOOL) limit:(CGFloat)dt {
    return MIN(ABS(_target - _initial), ABS(_target - _value)) < MAX(1, ABS(_velocity * dt));
}

- (void) tick:(CGFloat)dt {
    if ([self limit:dt]) {
        _target = _initial = _value;
        _velocity = 0.0f;
        return;
    }

    _velocity += [self speed] * dt * _direction;
    
    _value += _velocity * dt;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n->) dir:%d value:%.3f (init:%.2f->target:%.2f ~ prog:%.2f%%) velocity:%.2f speed:%.2f (aacel:%.2f @ jolt:%.1f%%)",
            _direction, _value, _initial, _target, ([self progress] * 100), _velocity, [self speed], _acceleration, ([self jolt] * 100)];
}

@end
