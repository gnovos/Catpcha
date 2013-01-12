//
//  LLVector.m
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

#import "LLVector.h"
#import "LLCurve.h"

@implementation LLVector 

- (id) init {
    return [self init:CGPointZero];
}

- (id) init:(CGPoint)inital {
    if (self = [super init]) {
        _x = [[LLCurve alloc] init:inital.x];
        _y = [[LLCurve alloc] init:inital.y];
    }
    return self;
}

- (void) setPosition:(CGPoint)position {
    _x.value = position.x;
    _y.value = position.y;
}

- (void) setTarget:(CGPoint)target {
    _x.target = target.x;
    _y.target = target.y;
}

- (void) tick:(CGFloat)dt {
    [self.x tick:dt];
    [self.y tick:dt];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\n ->x) %@\n ->y) %@\n\n", self.x, self.y];
}


@end
