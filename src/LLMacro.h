//
//  LLMacro.h
//  Catpcha
//
//  Created by Mason on 12/12/12.
//
//

#ifndef Catpcha_LLMacro_h
#define Catpcha_LLMacro_h

typedef struct { CGPoint from; CGPoint to; } CGLine;

static inline CGLine  CGLineMake(CGPoint from, CGPoint to) { return (CGLine){from, to}; }
static inline CGFloat CGLineSlopeX(CGLine line) { return line.to.x - line.from.x; }
static inline CGFloat CGLineSlopeY(CGLine line) { return line.to.y - line.from.y; }
static inline CGFloat CGLineSlope(CGLine line) {
    CGFloat mx = CGLineSlopeX(line);
    CGFloat my = CGLineSlopeY(line);
    if (mx == 0) {
        return 0;
    }
    return my / mx;
}

static inline CGFloat CGLineDistance(CGLine line) { return hypot(CGLineSlopeX(line), CGLineSlopeY(line)); };

static inline CGPoint CGRectCenter(CGRect rect) { return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); }

static inline CGRect CGRectEnvelope(CGRect rect, CGPoint point) {
    
    if (CGRectIsNull(rect)) {
        rect.origin = point;
    } else {
        if (point.x < CGRectGetMinX(rect)) {
            CGFloat dw = CGRectGetMinX(rect) - point.x;
            rect.origin.x = point.x;
            rect.size.width += dw;
        } else if (point.x > CGRectGetMaxX(rect)) {
            rect.size.width += point.x - CGRectGetMaxX(rect);
        }
        if (point.y < CGRectGetMinY(rect)) {
            CGFloat dh = CGRectGetMinY(rect) - point.y;
            rect.origin.y = point.y;
            rect.size.height += dh;
        } else if (point.y > CGRectGetMaxY(rect)) {
            rect.size.width += point.y - CGRectGetMaxX(rect);
        }
    }
    
    return rect;
}


#define CGRectGetCenter(x) CGPointMake(CGRectGetMidX(x), CGRectGetMidY(x))

#define LLRand(x) arc4random_uniform(x)
#define LLRandDeg LLRand(LL360Deg)
#define LLRandPercent (LLRand(1000000) / 1000000.0f)
#define LLRandSign ((LLRand(2) % 2 == 0) ? 1 : -1)

#define LLRandf(f) arc4random_uniform(f * 1000000.0f) / 1000000.0f

#define LLRandRange(low, high) (arc4random_uniform((high - low) * 1000000.0f) / 1000000.0f) - ((high - low) / 2.0f)
#define LLRandPoint(rect) GLKVector2Make(LLRandRange(rect.origin.x, rect.size.width + rect.origin.x), LLRandRange(rect.origin.y, rect.size.height + rect.origin.y))
#define LLRandPos(size, bounds) LLRandPoint(CGRectInset(bounds, size.width / 2.0f, size.height / 2.0f));

#define LLDEG2RAD(deg) (deg * M_PI / LL180Deg)
#define LLRAD2DEG(rad) (rad * LL180Deg / M_PI)

#define M_TAU ( 2 * M_PI)

#endif
