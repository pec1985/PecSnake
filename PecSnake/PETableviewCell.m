//
//  PETableviewCell.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/5/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PETableviewCell.h"

@implementation PETableviewCell


-(PELabel *)score
{
	if(score == nil)
	{
		score = [[PELabel alloc] init];
		[score setBackgroundColor:[UIColor clearColor]];
//		[score setTextAlignment:UITextAlignmentLeft];
		[[self contentView] addSubview:score];
	}
	return score;
}

-(PELabel *)speed
{
	if(speed == nil)
	{
		speed = [[PELabel alloc] init];
		[speed setBackgroundColor:[UIColor clearColor]];
//		[speed setTextAlignment:UITextAlignmentLeft];
		[[self contentView] addSubview:speed];
	}
	return speed;
}

-(PELabel *)date
{
	if(date == nil)
	{
		date = [[PELabel alloc] init];
		[date setBackgroundColor:[UIColor clearColor]];
//		[date setTextAlignment:UITextAlignmentLeft];
		[[self contentView] addSubview:date];
	}
	return date;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		score = [self score];
		speed = [self speed];
		date = [self date];
    }
    return self;
}

-(void)resize
{
	CGRect contentFrame = [[self contentView] bounds];

	contentFrame.origin.x = 0;
	contentFrame.size.width = 100;
	[[self date] setFrame:contentFrame];

	contentFrame.origin.x += 100;
	contentFrame.size.width = 90;
	[[self score] setFrame:contentFrame];

	contentFrame.origin.x += 90;
	contentFrame.size.width = 90;
	[[self speed] setFrame:contentFrame];
}

-(void)setScore:(NSString *)_score
{
	[[self score] setText:_score];
	[self resize];
}

-(void)setSpeed:(NSString *)_speed
{
	[[self speed] setText:_speed];
	[self resize];
}

-(void)setDate:(NSString *)_date
{
	_date = [_date stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
	[[self date] setText:_date];
	[self resize];
}

-(void)dealloc
{
	[date release];
	[score release];
	[speed release];
	[super dealloc];
}

@end
