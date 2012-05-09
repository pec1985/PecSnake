//
//  PESquareView.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PESquareView.h"

@implementation PESquareView

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder])
	{
		[self setBackgroundColor:[UIColor blackColor]];
	}
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
		[self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

	CGRect bounds = [self bounds];
	CGSize size = bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat width = size.width;
	CGFloat height = size.height;
	
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextSetLineWidth(context, 2.0);
	
	CGContextMoveToPoint(context,bounds.origin.x, bounds.origin.y);
	CGContextAddLineToPoint(context, bounds.origin.x, height);
	CGContextAddLineToPoint(context, width, height);
	CGContextAddLineToPoint(context, width, bounds.origin.y);
	CGContextAddLineToPoint(context, bounds.origin.x, bounds.origin.y);
	CGContextStrokePath(context);
	[super drawRect:rect];
}

@end
