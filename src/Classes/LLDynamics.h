//
//  LLDynamics.h
//  Catpcha
//
//  Created by Mason on 12/14/12.
//
//

#import "LLVector.h"
#import "LLCurve.h"
#import "LLColor.h"

@interface LLDynamics : NSObject

@property (nonatomic, strong, readonly) LLVector* position;
@property (nonatomic, strong, readonly) LLCurve* angle;
@property (nonatomic, strong, readonly) LLVector* scale;
@property (nonatomic, strong, readonly) LLColor* color;

- (void) setLocation:(CGPoint)position;
- (void) setTarget:(CGPoint)target;

- (void) setRotation:(CGFloat)angle;
- (void) setHeading:(CGFloat)target;

- (void) setScaleValue:(CGPoint)scale;
- (void) setScaleTarget:(CGPoint)target;

- (void) setColorValue:(LLRGBA)color;
- (void) setColorTarget:(LLRGBA)target;

- (void) tick:(CGFloat)dt;

@end
