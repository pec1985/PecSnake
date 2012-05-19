//
//  PELabel.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PELabel.h"

@implementation PELabel

-(void)props
{
	[self setBackgroundColor:[UIColor blackColor]];
	[self setTextColor:[UIColor whiteColor]];
	[self setTextAlignment:UITextAlignmentCenter];
	[self setFont:[UIFont fontWithName:@"DS-Digital" size:20]];
}

-(id)init
{
	if(self = [super init])
	{
		[self props];
	}
	return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder])
	{
		[self props];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		[self props];
	}
	return self;
}

@end
