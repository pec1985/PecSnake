//
//  PEButton.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/1/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PEButton.h"
#import "PEUtils.h"

@implementation PEButton

-(void)props
{
		[self setBackgroundColor:[PEUtils webColor:@"#333"]];
		[self setTextColor:[UIColor whiteColor]];
		[self setFont:[UIFont fontWithName:@"DS-Digital" size:22]];
		[self setTextAlignment:UITextAlignmentCenter];
		[self setUserInteractionEnabled:YES];
 }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 		[self props];
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
 		[self props];
	}
    return self;
}

- (void)drawRect:(CGRect)rect
{

	[super drawRect:rect];
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
	

}

-(void)resetColor
{
	[self setBackgroundColor:[PEUtils webColor:@"#333"]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	[self resetColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self resetColor];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[self resetColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self setBackgroundColor:[PEUtils webColor:@"#666"]];
}

@end