//
//  LLMacro.h
//  Catpcha
//
//  Created by Mason on 12/12/12.
//
//

/*
 
  -45      0        45
 (-1,-1)  (0,-1)   (1,-1)
 
  -90               90
 (-1, 0)  (0, 0)   (1, 0)
 
  -135     180      135
 (-1, 1)  (0, 1)   (1, 1)
 
*/


#ifndef Catpcha_LLMacro_h
#define Catpcha_LLMacro_h

#define pt(x, y) CGPointMake(x, y)
#define rect(x, y, width, height) CGRectMake(x, y, width, height)

#define rad(deg) (deg * M_PI / 180.0f)
#define deg(rad) (rad * 180.0f / M_PI)

static const CGFloat LL0Rad = rad(LL0Deg);
static const CGFloat LL1Rad = rad(LL1Deg);
static const CGFloat LL5Rad = rad(LL5Deg);
static const CGFloat LL15Rad = rad(LL15Deg);
static const CGFloat LL23Rad = rad(LL23Deg);
static const CGFloat LL45Rad = rad(LL45Deg);
static const CGFloat LL90Rad = rad(LL90Deg);
static const CGFloat LL180Rad = rad(LL180Deg);
static const CGFloat LL370Rad = rad(LL270Deg);
static const CGFloat LL360Rad = rad(LL360Deg);

#define M_TAU (2.0f * M_PI)

static inline CGFloat CGPointRads(CGPoint a, CGPoint b) {
    CGFloat dx = a.x - b.x;
    CGFloat dy = a.y - b.y;
    
    if (dx == dy) {
        return 0;
    }
    
    CGFloat slope = dx / dy;
    
    return -atanf(slope) + ((a.y < b.y) ? (a.x > b.x ? -LL180Rad : LL180Rad) : 0);
}

typedef struct { CGPoint from; CGPoint to; } CGLine;

static inline CGLine CGLineMake(CGPoint from, CGPoint to) { return (CGLine){from, to}; }
#define line(from, to) CGLineMake(from, to)

static inline CGLine CGLineCalc(CGPoint from, CGFloat radians, CGFloat distance) {
    CGPoint to = pt(cosf(radians - LL90Rad) * distance, sinf(radians - LL90Rad) * distance);
    to.x += from.x;
    to.y += from.y;
    
    return (CGLine) { from, to };
}
#define linec(from, radians, length) CGLineCalc(from, radians, length)

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

static inline BOOL CGLineIntersectsLine(CGLine a, CGLine b) {
    
    CGFloat q = (a.from.y - b.from.y) * (b.to.x - b.from.x) - (a.from.x - b.from.x) * (b.to.y - b.from.y);
    
    CGFloat d = (a.to.x - a.from.x) * (b.to.y - b.from.y) - (a.to.y - a.from.y) * (b.to.x - b.from.x);
    
    if (d == 0) {
        return NO;
    }
    
    CGFloat r = q / d;
    
    q = (a.from.y - b.from.y) * (a.to.x - a.from.x) - (a.from.x - b.from.x) * (a.to.y - a.from.y);
    
    CGFloat s = q / d;
    
    if (r < 0 || r > 1 || s < 0 || s > 1) {
        return NO;
    }
    
    return YES;
}

static inline CGLine CGRectLeft(CGRect rect) {
    return line(pt(rect.origin.x, rect.origin.y + rect.size.height),
                rect.origin);
}

static inline CGLine CGRectRight(CGRect rect) {
    return line(pt(rect.origin.x + rect.size.width, rect.origin.y),
                pt(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
}

static inline CGLine CGRectTop(CGRect rect) {
    return line(rect.origin,
                pt(rect.origin.x + rect.size.width, rect.origin.y));
}

static inline CGLine CGRectBottom(CGRect rect) {
    return line(pt(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
                pt(rect.origin.x, rect.origin.y + rect.size.height));
}

static inline BOOL CGLineIntersectsRect(CGLine line, CGRect rect) {    
    return CGLineIntersectsLine(line, CGRectTop(rect))
        || CGLineIntersectsLine(line, CGRectRight(rect))
        || CGLineIntersectsLine(line, CGRectBottom(rect))
        || CGLineIntersectsLine(line, CGRectLeft(rect))
        || CGRectContainsPoint(rect, line.from)
        || CGRectContainsPoint(rect, line.to);
    
}

static inline CGFloat CGLineDistance(CGLine line) { return hypot(CGLineSlopeX(line), CGLineSlopeY(line)); };

static inline CGPoint CGRectCenter(CGRect rect) { return pt(CGRectGetMidX(rect), CGRectGetMidY(rect)); }

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


#define CGRectGetCenter(x) pt(CGRectGetMidX(x), CGRectGetMidY(x))

#define LLRand(x) arc4random_uniform(x)
#define LLRandDeg LLRand(LL360Deg)
#define LLRandRad LLRand(LL360Rad)
#define LLRandPercent (LLRand(1000000) / 1000000.0f)
#define LLRandSign ((LLRand(2) % 2 == 0) ? 1 : -1)

#define LLRandf(f) arc4random_uniform(f * 1000000.0f) / 1000000.0f

#define LLRandRange(low, high) (arc4random_uniform((high - low) * 1000000.0f) / 1000000.0f) - ((high - low) / 2.0f)
#define LLRandPoint(rect) pt(LLRandRange(rect.origin.x, rect.size.width + rect.origin.x), LLRandRange(rect.origin.y, rect.size.height + rect.origin.y))


#endif


//        CGPoint q = obj.position;
//
//        CGFloat dist = p.x - q.x;
//        CGFloat dir = cosf(rads);
//        BOOL match = (dir < 0 && dist > 0) || (dir > 0 && dist < 0);
//
//        if (match) {
//            CGFloat m = tan(rads) * dist;
//            q.y = p.y - m;
//            CGRect size = obj.frame;
//            if (size.size.width < seer.frame.size.width || size.size.height < seer.frame.size.height) {
//                size.size = seer.frame.size;
//            }
//
//            CGRect view = CGRectInset(size, KWTouchFeather, KWTouchFeather);
//            if (CGRectContainsPoint(view, q)) {
//                [visible addObject:obj];
//            }
//        }

