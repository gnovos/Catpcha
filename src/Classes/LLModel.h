//
//  LLModel.h
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#import "SPDisplayObject.h"
#import "LLCurve.h"
#import "LLVector.h"
#import "LLColor.h"

@interface LLModel : SPDisplayObjectContainer

@property (nonatomic, assign, readonly) CGPoint center;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong, readonly) LLVector* coords;
@property (nonatomic, strong, readonly) LLCurve* degrees;
@property (nonatomic, strong, readonly) LLVector* rescale;
@property (nonatomic, strong, readonly) LLColor* chroma;

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint target;
@property (nonatomic, assign) CGFloat rad;
@property (nonatomic, assign) CGFloat deg;
@property (nonatomic, assign) CGFloat heading;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat growth;

@property (nonatomic, assign) LLRGBA color;

@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign) CGRect constraints;

@property (nonatomic, assign) CGFloat vision;

- (CGLine) sight;
- (CGLine) sight:(CGFloat)radians;

- (id) init:(CGRect)bounds;
- (void) setup;

- (void) reclaim:(SPEvent*)event;
- (void) tween:(NSString*)property value:(CGFloat)value duration:(CGFloat)time;
- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time;
- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time delay:(CGFloat)delay;

- (void) onTick:(SPEnterFrameEvent*)event;

- (NSArray*) children;
- (NSArray*) models;

@end
