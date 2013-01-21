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

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint target;

- (id) init;
- (id) init:(CGPoint)inital;

- (void) tick:(CGFloat)dt;

@end
