//
//  LLColor.h
//  Catpcha
//
//  Created by Mason on 12/30/12.
//
//

#import "LLCurve.h"

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} LLRGBA;

@interface LLColor : NSObject

@property (nonatomic, strong, readonly) LLCurve* r;
@property (nonatomic, strong, readonly) LLCurve* g;
@property (nonatomic, strong, readonly) LLCurve* b;
@property (nonatomic, strong, readonly) LLCurve* a;

- (void) setColor:(LLRGBA)color;
- (void) setTarget:(LLRGBA)target;

- (void) tick:(CGFloat)dt;

@end
