//
//  LLVector.h
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

#import "LLCurve.h"

@interface LLVector : NSObject

@property (nonatomic, strong, readonly) LLCurve* x;
@property (nonatomic, strong, readonly) LLCurve* y;

- (id) init;
- (id) init:(CGPoint)inital;

- (void) setPosition:(CGPoint)position;
- (void) setTarget:(CGPoint)target;

- (void) tick:(CGFloat)dt;

@end
