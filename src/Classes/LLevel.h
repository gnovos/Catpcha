//
//  LLevel.h
//  Catpcha
//
//  Created by Mason on 11/28/12.
//
//

#import "LLModel.h"

@interface LLevel : LLModel

@property (nonatomic, assign, readonly) NSUInteger level;
@property (nonatomic, strong, readonly) NSMutableArray* objects;

- (id) initLevel:(NSUInteger)level withFrame:(CGRect)frame;

@end
