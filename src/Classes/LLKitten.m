//
//  LLKitten.m
//  Catpcha
//
//  Created by Mason on 1/4/13.
//
//

#import "LLKitten.h"

@implementation LLKitten

- (void) setup {
    SPQuad* bg = [[SPQuad alloc] initWithWidth:self.size.width height:self.size.height];
    [bg setColor:0xffffff ofVertex:0];
    [bg setColor:0x223344 ofVertex:1];
    [bg setColor:0x223344 ofVertex:2];
    [bg setColor:0x555555 ofVertex:3];
    
    [self addChild:bg];
}

@end
