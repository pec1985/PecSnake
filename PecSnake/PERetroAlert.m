//
//  NSObject+PERetroAlert.m
//  Simulator Game
//
//  Created by Pedro Enrique on 4/30/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PERetroAlert.h"
#import "PEButton.h"

@interface PERetroAlert()
{
	UIView *_mainView;
	UIView *_overlayView;
	UIView *_alertView;
	UIView *_innerView;
	UILabel *_title;
	UILabel *_message;
	NSArray *_buttons;
}

@property(nonatomic, retain)UIView *_view;

@end


@implementation PERetroAlert
@synthesize delegate;

@synthesize _view;

-(void) dealloc
{
	delegate = nil;
	[_mainView release];
	[_overlayView release];
	[_alertView release];
	[_innerView release];
	[_title release];
	[_message release];
	[_buttons release];
	self._view = nil;
	[super dealloc];
}

-(id)init
{
	if(self = [super init])
	{
		_mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_overlayView = [[UIView alloc] initWithFrame:[_mainView bounds]];
		_alertView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 200)];
		_title = [[UILabel alloc] init];
		_message = [[UILabel alloc] init];
		
		
		CGRect frame = [_alertView bounds];
		frame.size.width -= 2;
		frame.size.height -= 2;
		frame.origin.x += 1;
		frame.origin.y += 1;
		_innerView = [[UIView alloc] initWithFrame:frame];
		[_innerView setBackgroundColor:[UIColor blackColor]];
		[_overlayView setBackgroundColor:[UIColor whiteColor]];
		[_overlayView setAlpha:0.15f];
		[_alertView setBackgroundColor:[UIColor whiteColor]];
		
		[_title setTextAlignment:UITextAlignmentCenter];
		[_message setTextAlignment:UITextAlignmentCenter];
		
		[_title setBackgroundColor:[UIColor clearColor]];
		[_message setBackgroundColor:[UIColor clearColor]];
		
		[_title setTextColor:[UIColor whiteColor]];
		[_message setTextColor:[UIColor whiteColor]];
		
		[_title setFont:[UIFont fontWithName:@"DS-Digital" size:25]];
		[_message setFont:[UIFont fontWithName:@"DS-Digital" size:20]];
		
		[_title setNumberOfLines:0];
		[_message setNumberOfLines:0];
		
		[_mainView addSubview:_overlayView];
		[_innerView addSubview:_title];
		[_innerView addSubview:_message];
		[_alertView addSubview:_innerView];
		
		[_mainView setAlpha:0.0f];
		[self._view addSubview:_mainView];
		
	}
	return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)msg buttonNames:(NSArray *)buttons inView:(UIView *)view
{
	[self set_view:view];
	self = [self init];
	[_title setText:title];
	[_message setText:msg];
	_buttons = [buttons copy];
	
	return self;
}

-(void)clicked:(UITapGestureRecognizer *)sender
{
	[self hide];
	UILabel *a = (UILabel *)sender.view;
	if ([delegate respondsToSelector:@selector(retroAlertDidSelect:)]) {
		[delegate retroAlertDidSelect:a.text];
	}
}

-(UIView *)buttonWithTitle:(NSString *)title
{
	
	CGRect mainViewframe = [_innerView bounds];
	
	mainViewframe.size.width -= 40;
	mainViewframe.origin.x = 20;
	mainViewframe.size.height = 40;
	
	PEButton *btn = [[PEButton alloc] initWithFrame:mainViewframe];
	CGRect btnBounds = [btn bounds];
	
	btnBounds.size.height-=2;
	btnBounds.size.width-=2;
	btnBounds.origin.x += 1;
	btnBounds.origin.y += 1;
	[btn setText:title];
	
	UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
	[click setNumberOfTapsRequired:1];
	[btn addGestureRecognizer:click];
	[click release];
	return [btn autorelease];
}

- (void)hide
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
									  animationWithKeyPath:@"transform"];
	
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale4 = CATransform3DMakeScale(0.2, 0.2, 1);
	
    NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale4],
							nil];
    [animation setValues:frameValues];
	
    NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:1],
						   nil];    
    [animation setKeyTimes:frameTimes];
	
    [animation setFillMode: kCAFillModeForwards];
    [animation setRemovedOnCompletion: NO];
    [animation setDuration: 0.25];
	[animation setDelegate:self];
	
    [_alertView.layer addAnimation:animation forKey:@"hidepopup"];
	
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	[_alertView.layer removeAllAnimations];
	[_mainView removeFromSuperview];
	self._view = nil;
}

- (void)attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
									  animationWithKeyPath:@"transform"];
	
    CATransform3D scale1 = CATransform3DMakeScale(0.2, 0.2, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
	
    NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							[NSValue valueWithCATransform3D:scale4],
							nil];
    [animation setValues:frameValues];
	
    NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:0.9],
						   [NSNumber numberWithFloat:1.0],
						   nil];    
    [animation setKeyTimes:frameTimes];
	
    [animation setFillMode: kCAFillModeForwards];
    [animation setRemovedOnCompletion: YES];
    [animation setDuration: 0.25];
	
    [_alertView.layer addAnimation:animation forKey:@"popup"];
}

-(void)boing
{
	NSString *a = [[NSBundle mainBundle] pathForResource:@"boing" ofType:@"wav"];
	NSURL *url = [NSURL fileURLWithPath:a];
	NSError *err = nil;
	
//	AudioServicesCreateSystemSoundID((CFURLRef)a, &url);
//	AudioServicesPlaySystemSound(url);

	AVAudioPlayer *sound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:(NSError **)&err];

	if(err != nil)
		NSLog(@"%@",[err description]);
	[sound performSelectorInBackground:@selector(play) withObject:nil];
	[sound release];
}

-(void)showAlert
{
	CGRect frame = [_innerView bounds];
	[_title sizeToFit];
	
	CGRect titleFrame = [_title frame];
	titleFrame.size.width = frame.size.width;
	titleFrame.origin.y = 10;
	[_title setFrame:titleFrame];
	
	[_message sizeToFit];
	
	CGRect messageFrame = [_message frame];
	messageFrame.size.width = frame.size.width;
	messageFrame.origin.y = titleFrame.size.height + 20;
	
	[_message setFrame:messageFrame];
	
	
	CGFloat top = titleFrame.size.height + messageFrame.size.height + 40;
	
	for(NSString *titles in _buttons)
	{
		UIView *btn = [[self buttonWithTitle:titles] retain];
		[_innerView addSubview:btn];
		CGRect btnFrame = [btn frame];
		btnFrame.origin.y = top;
		[btn setFrame:btnFrame];		
		top += btnFrame.size.height + 20;
		[btn release];
	}
	
	CGFloat height = titleFrame.size.height + messageFrame.size.height + top - 40;
	
	frame = [_innerView bounds];
	frame.size.height = height;
	
	[_innerView setFrame:frame];
	frame.size.height += 2;
	frame.size.width += 2;
	frame.origin.y -= 1; 
	frame.origin.x -= 1; 
	[_alertView setBounds:frame];
	
	[UIView animateWithDuration:0.1
					 animations:^{ [_mainView setAlpha:1.0f]; }
					 completion:^(BOOL finished){
						 [_mainView addSubview:_alertView];
						 [self attachPopUpAnimation];
					 }
	 ];

}

-(void)show
{
	[self boing];
	[self showAlert];
}

-(void)showWithNoSound
{
	[self showAlert];
}

@end
