//
//  PETestViewControllerViewController.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/23/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PETestViewController.h"

@interface PETestViewController ()
{
	CGPoint swipeOldPoint;
	BOOL swipeDistanceThresholdPassed;
	int swipeDistanceThreshold;
	float swipeAngleThreshold;
}
@end
@implementation PETestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		swipeDistanceThresholdPassed = NO;
		swipeDistanceThreshold = 25;
		swipeAngleThreshold = M_PI/12;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)fingerMoved:(UIPanGestureRecognizer *)event
{
	NSString *direction = @"";
	
	CGPoint currentPoint = [event translationInView:[self view]];
	
	
	CGFloat swipeOldPointX = swipeOldPoint.x;
	CGFloat currentPointX = currentPoint.x;
	CGFloat swipeOldPointY = swipeOldPoint.y;
	CGFloat currentPointY = currentPoint.y;
	
	
	CGFloat xDiff = abs(swipeOldPointX - currentPointX);
	CGFloat yDiff = abs(swipeOldPointY - currentPointY);
	CGFloat distance = sqrt(pow(swipeOldPointX - currentPointX,2) + pow(swipeOldPointY - currentPointY,2));
	BOOL angleOK;
	!swipeDistanceThresholdPassed && (swipeDistanceThresholdPassed = distance > swipeAngleThreshold);
	if (swipeDistanceThresholdPassed) {
		
		if (distance <= swipeAngleThreshold || xDiff == 0 || yDiff == 0) {
			angleOK = true;
		} else if (xDiff > yDiff) {
			angleOK = atan(yDiff/xDiff) < swipeAngleThreshold;
		} else {
			angleOK = atan(xDiff/yDiff) < swipeAngleThreshold;
		}
		if(!angleOK)
		{
			return;
		} 
		else
		{
			if (xDiff > yDiff) {
				direction =  swipeOldPointX - currentPointX > 0 ? @"left" : @"right";
			} else {
				direction =  swipeOldPointY - currentPointY < 0 ? @"down" : @"up";
			}
		}
	}
	NSLog(@"%@",direction);	
	
	//	
	//	var xDiff = Math.abs(this._touchStartLocation.x - x),
	//	yDiff = Math.abs(this._touchStartLocation.y - y),
	//	distance = Math.sqrt(Math.pow(this._touchStartLocation.x - x,2) + Math.pow(this._touchStartLocation.y - y,2)),
	//
	
	swipeOldPoint = currentPoint;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
