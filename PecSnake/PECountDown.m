//
//  PECountDown.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/19/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PECountDown.h"
#import "PELabel.h"

@interface PECountDown()
{
	NSInteger _number;
	UIView *_view;
	UIView *overLay;
	PELabel *labelNumber;
}

@end
@implementation PECountDown
@synthesize delegate;

-(id)initWithCountDown:(NSInteger)number inView:(UIView *)view
{
	if(self = [super init])
	{
		_number = number;
		_view = view;
		overLay = [[UIView alloc] initWithFrame:[view bounds]];
		[overLay setBackgroundColor:[UIColor clearColor]];
		[_view addSubview:overLay];
	}
	return self;
}

-(PELabel *)numberLabelWithNumber:(NSInteger)number
{
	PELabel *label = [[PELabel alloc] initWithFrame:[_view bounds]];
	[label setText:[NSString stringWithFormat:@"%i",number]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label adjustsFontSizeToFitWidth];
	[label setFont:[[label font] fontWithSize:200]];
	return [label autorelease];
}

-(void)startCountDown
{
	if(labelNumber != nil)
	{
		[labelNumber removeFromSuperview];
	}
	switch (_number) {
		case 1:
			[PEUtils playSoundFromFile:@"beep2"];
		break;
		case 0:
			[delegate countDownDidFinish];
			[overLay removeFromSuperview];
			[overLay release];
			return;
		default:
			[PEUtils playSoundFromFile:@"beep1"];
			break;
	}
	
	if([delegate respondsToSelector:@selector(countDownChanged:)])
		[delegate countDownChanged:_number];
	


	CAKeyframeAnimation *animation = [CAKeyframeAnimation
									  animationWithKeyPath:@"transform"];
	
    CATransform3D scale1 = CATransform3DMakeScale(0.2, 0.2, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
	
    NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale4],
							nil];
    [animation setValues:frameValues];
	
    NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:0.8],
						   nil];    
    [animation setKeyTimes:frameTimes];
	
    [animation setFillMode: kCAFillModeForwards];
    [animation setRemovedOnCompletion: YES];
    [animation setDuration: 0.3];
	[animation setDelegate:self];
	labelNumber = [self numberLabelWithNumber:_number--];
    [[labelNumber layer] addAnimation:animation forKey:@"popup"];
	[_view addSubview:labelNumber];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(startCountDown) userInfo:nil repeats:NO];
}

@end
