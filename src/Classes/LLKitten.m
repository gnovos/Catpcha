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
    [bg setColor:0x992233 ofVertex:0];
    [bg setColor:0x99FF33 ofVertex:1];
    [bg setColor:0x9922FF ofVertex:2];
    [bg setColor:0xFF2233 ofVertex:3];
    
    [self addChild:bg];
}

@end
