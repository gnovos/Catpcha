//
//  LLModel.h
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#import "SPDisplayObject.h"
#import "LLDynamics.h"

@interface LLModel : SPDisplayObjectContainer

@property (nonatomic, strong, readonly) LLDynamics* dynamics;
@property (nonatomic, assign, readonly) CGPoint center;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign) CGRect constraints;

@property (nonatomic, assign) CGFloat vision;

- (CGLine) sight;

- (id) init:(CGRect)bounds;
- (void) setup;

- (void) reclaim:(SPEvent*)event;
- (void) tween:(NSString*)property value:(CGFloat)value duration:(CGFloat)time;
- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time;
- (void) tween:(id)target property:(NSString*)property value:(CGFloat)value duration:(CGFloat)time delay:(CGFloat)delay;

- (void) setTarget:(CGPoint)position;

- (void) onTick:(SPEnterFrameEvent*)event;

- (NSArray*) children;
- (NSArray*) models;

@end
