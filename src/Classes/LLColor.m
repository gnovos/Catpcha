//
//  LLColor.m
//  Catpcha
//
//  Created by Mason on 12/30/12.
//
//

#import "LLColor.h"

@implementation LLColor

- (id) init {
    if (self = [super init]) {
        _r = [[LLCurve alloc] init:0.0f];
        _g = [[LLCurve alloc] init:0.0f];
        _b = [[LLCurve alloc] init:0.0f];
        _a = [[LLCurve alloc] init:1.0f];
    }
    return self;
}

- (LLRGBA) color { return LLRGBAMake(_r.value, _g.value, _b.value, _a.value); }
- (void) setColor:(LLRGBA)color {
    _r.value = color.r;
    _g.value = color.g;
    _b.value = color.b;
    _a.value = color.a;
}

- (LLRGBA) target { return LLRGBAMake(_r.target, _g.target, _b.target, _a.target); }
- (void) setTarget:(LLRGBA)target {
    _r.target = target.r;
    _g.target = target.g;
    _b.target = target.b;
    _a.target = target.a;
}

- (void) tick:(CGFloat)dt {
    [self.r tick:dt];
    [self.g tick:dt];
    [self.b tick:dt];
    [self.a tick:dt];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n ->r) %@\n ->b) %@\n ->b) %@\n ->a) %@\n\n", self.r, self.g, self.b, self.a];
}


@end
