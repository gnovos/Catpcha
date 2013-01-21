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

static inline LLRGBA LLRGBAMake (CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return (LLRGBA) { r, g, b, a };
}

@interface LLColor : NSObject

@property (nonatomic, strong, readonly) LLCurve* r;
@property (nonatomic, strong, readonly) LLCurve* g;
@property (nonatomic, strong, readonly) LLCurve* b;
@property (nonatomic, strong, readonly) LLCurve* a;

@property (nonatomic, assign) LLRGBA color;
@property (nonatomic, assign) LLRGBA target;

- (void) tick:(CGFloat)dt;

@end
