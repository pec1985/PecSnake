//
//  PEScores.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/13/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PEScores.h"

@implementation PEScores
@synthesize score;

-(void)addScore:(int)_score
{
	self.score += _score;
}

@end
