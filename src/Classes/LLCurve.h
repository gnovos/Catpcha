//
//  LLMoment.h
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

@interface LLCurve : NSObject

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat acceleration;
@property (nonatomic, assign) CGFloat target;

- (void) setAdjust:(CGFloat)value;
- (CGFloat) adjust;

- (id) init;
- (id) init:(CGFloat)initial;

- (void) tick:(CGFloat)dt;

@end
