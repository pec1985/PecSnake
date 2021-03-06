//
//  PEGameViewController.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PEGameViewController.h"

typedef enum {
	WormDirectionLeft,
	WormDirectionRight,
	WormDirectionTop,
	WormDirectionBottom
} WormDirection;



static NSString *PAUSE_EVENT = @"pause";
static NSString *PAUSED_EVENT = @"paused";

#define RELEASE_TO_NIL(x) { if (x!=nil) { [x release]; x = nil; } }


@interface PEGameViewController ()
{
@private
	WormDirection direction;
	NSTimer *timer;
	NSTimeInterval interVal;
	UIView *board1;
	UIView *board2;
	UIColor *boardColor;
	UIColor *boardMargin;
	PEScores *finalScore;
	PESquareView *candy;
	PESquareView *extraCandy;
	PERetroAlert *retroAlert;
	NSInteger numberOfCandy;
	int time;
	int currentScore;
	int extraScore;
	BOOL isPaused;
	BOOL isCountingDown;
	BOOL isFirstTime;
}

-(void)resetCandy;
-(UIView *)candy;
-(PESquareView *)extraCandy;
-(void)showExtraCandy:(id)sender;

@end

@implementation PEGameViewController
@synthesize scoreView;
@synthesize scoreLabel;
@synthesize gameRoom;
@synthesize pause;
@synthesize flashView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		direction = WormDirectionRight;
		numberOfCandy = 0;
		interVal = 0.12f;
		time = 1;
		currentScore = 0;
		extraScore = 0;
		isPaused = NO;
		isFirstTime = YES;
    }
    return self;
}

#pragma mark - View Controller Stuff

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	finalScore = [[PEScores alloc] init];
	[[self view] setBackgroundColor:[PEUtils webColor:@"#333"]];
	[pause sizeToFit];
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: 0    SPEED:  1"]];
	[scoreLabel setTextAlignment:UITextAlignmentLeft];
	[scoreView setBackgroundColor:[PEUtils webColor:@"#333"]];
	[scoreLabel setBackgroundColor:[PEUtils webColor:@"#333"]];
	[pause setBackgroundColor:[PEUtils webColor:@"#333"]];
	
	UITapGestureRecognizer *_pauseClicked = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseClicked:)];
	UISwipeGestureRecognizer *_downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
	UISwipeGestureRecognizer *_upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
	UISwipeGestureRecognizer *_leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
	UISwipeGestureRecognizer *_rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];

	[_pauseClicked setNumberOfTapsRequired:1];
	[_downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
	[_upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
	[_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
	[_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];

	[scoreView addGestureRecognizer: _pauseClicked];
	[gameRoom setGestureRecognizers:[NSArray arrayWithObjects:_downSwipe,_upSwipe,_leftSwipe,_rightSwipe, nil]];
	
	RELEASE_TO_NIL(_pauseClicked);
	RELEASE_TO_NIL(_downSwipe);
	RELEASE_TO_NIL(_upSwipe);
	RELEASE_TO_NIL(_leftSwipe);
	RELEASE_TO_NIL(_rightSwipe);
	
	extraCandy = [self extraCandy];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseClicked:) name:PAUSE_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToBackground:) name:PAUSED_EVENT object:nil];
	
	wormController = [[PEWormController alloc] initWithParentView:gameRoom];
	[wormController setDelegate:self];
	
	[wormController createWormWithLength:1];
	[self resetCandy];
	
}

-(void)countDownDidFinish
{
	NSLog(@"end countdown");
	isCountingDown = NO;
	RELEASE_TO_NIL(countDown)
	[self startTimer];
}

-(void)startCountDown
{
	NSLog(@"Start countdown");
	isCountingDown = YES;
	if(countDown == nil)
	{
		countDown = [[PECountDown alloc] initWithCountDown:3 inView:[self view]];
		[countDown setDelegate:self];
	}
	[countDown startCountDown];
}

- (void)viewDidUnload
{
	[self setScoreView:nil];
	[self setFlashView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
//	NSLog(@"dealloc");

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	RELEASE_TO_NIL(countDown)
	RELEASE_TO_NIL(wormController)
	RELEASE_TO_NIL(finalScore)
	RELEASE_TO_NIL(extraCandy)	
	RELEASE_TO_NIL(candy)
	RELEASE_TO_NIL(gameRoom)	
	RELEASE_TO_NIL(scoreLabel)
	RELEASE_TO_NIL(pause)
	RELEASE_TO_NIL(scoreView)
	RELEASE_TO_NIL(flashView)
	[super dealloc];
}

#pragma mark - Game Start and End

-(void)startGame
{
	if(retroAlert != nil) return;
	NSArray *buttonNames = [[NSArray alloc] initWithObjects:@"go", nil];
	retroAlert = [[PERetroAlert alloc] initWithTitle:@"new game" message:@"are you ready?!" buttonNames:buttonNames inView:[self view]];
	[retroAlert setDelegate:self];
	[retroAlert show];
	[buttonNames release];
	buttonNames = nil;
}

-(void)endGame
{
	[timer invalidate];
	retroAlert = [[PERetroAlert alloc] initWithTitle:@"game over" message:@"sorry!" buttonNames:[NSArray arrayWithObject:@"end"] inView:[self view]];
	[retroAlert setDelegate:self];
	[retroAlert show];
	isPaused = YES;	
	
	NSUserDefaults *urs = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *ar = [[urs objectForKey:@"game_scores"] mutableCopy];
	if(!ar)
		ar = [[NSMutableArray alloc] init];
	
	NSDate *localDate = [NSDate date];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
	[dateFormatter setDateFormat: @"MM-dd-yy"];
	NSString *dateString = [dateFormatter stringFromDate: localDate];
	
	NSDictionary *sc = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[finalScore score]],@"score",[NSNumber numberWithInt:time],@"time", dateString, @"date", nil];
	
	[ar addObject:sc];
	
	[urs setObject:ar forKey:@"game_scores"];
	[urs synchronize];
	[ar release];
}

#pragma mark - Move Worm Directions


-(void)moveWorm
{
	switch (direction) {
		case WormDirectionLeft:
    		[wormController moveLeft];
    		break;
		case WormDirectionRight:
			[wormController moveRight];
			break;
		case WormDirectionTop:
			[wormController moveUp];
			break;
		case WormDirectionBottom:
			[wormController moveDown];
			break;
	}
}

#pragma mark - Worm Stuff



#pragma mark - Views, Candies, etc...

-(PESquareView *)candy
{
	if(candy == nil)
	{
		candy = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		[candy setBackgroundColor:[UIColor redColor]];
		[gameRoom addSubview:candy];
	}
	return candy;
}

-(PESquareView *)extraCandy
{
	if(extraCandy == nil)
	{
		extraCandy = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		[extraCandy setBackgroundColor:[UIColor yellowColor]];
		[extraCandy setHidden:YES];
		[gameRoom addSubview:extraCandy];
	}
	
	[self resetExtraCandy];
	return extraCandy;
}


#pragma mark - Game Timers

-(void)startTimer
{
	if(timer && [timer isValid])
		[timer invalidate];
	timer = [[NSTimer scheduledTimerWithTimeInterval:interVal target: self selector:@selector(moveWorm) userInfo:self repeats:YES] retain];
}

#pragma mark - Extra Candy Stuff

-(void)resetExtraCandy
{
	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
	for(PESquareView *w in [wormController wormArray])
	{
		if(CGPointEqualToPoint(center, [w center]))
		{
			[self resetExtraCandy];
			return;
		}
	}
	if(CGPointEqualToPoint(center, [candy center]))
	{
		[self resetExtraCandy];
		return;
	}
	[extraCandy setCenter:center];
	[wormController setExtraCandyCenter:center];
}


-(void)showExtraCandy:(id)sender
{
	[extraCandy setHidden:NO];
	[wormController setExtraCandyHidden:NO];
	[UIView animateWithDuration: 5.0
					 animations:^{
						 [extraCandy setAlpha:0.25];
					 }
					 completion:^(BOOL complete){
						 [extraCandy setAlpha:1.0];
						 [extraCandy setHidden:YES];
						 [wormController setExtraCandyHidden:YES];
					 }
	 ];

	
	[self resetExtraCandy];
}

#pragma mark - Normal Candy Stuff

-(void)resetCandy
{
	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
	for(PESquareView *w in [wormController wormArray])
	{
		if(CGPointEqualToPoint(center, [w center]))
		{
			[self resetCandy];
			return;
		}
	}
	[[self candy] setCenter:center];
//	NSLog(@"%f",center.x);
	[wormController setCandyCenter:center];
	if(numberOfCandy == 5)
	{
		numberOfCandy = 0;
		interVal -= 0.005f;
		time++;
		[timer invalidate];
		[self startTimer];
		[self showExtraCandy:nil];
	}
}

#pragma mark - Scores And Points

-(void)updateScoreWithPoints:(int)points
{
	
	[finalScore addScore: points];	
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i    SPEED: %i", [finalScore score], time]];
	
}

#pragma mark - User Actions

- (void)swipeLeft:(id)sender {
	if(direction != WormDirectionRight)
		direction = WormDirectionLeft;
}

- (void)swipeRight:(id)sender {
	if(direction != WormDirectionLeft)
		direction = WormDirectionRight;
}
- (void)swipeUp:(id)sender {
	if(direction != WormDirectionBottom)
		direction = WormDirectionTop;
}

- (void)swipeDown:(id)sender {
	if(direction != WormDirectionTop)
		direction = WormDirectionBottom;
}

-(void)pauseClicked:(id)sender
{
	NSLog(@"isCountingDown %i",isCountingDown);
	if(isPaused == YES || isCountingDown == YES) return;
	isPaused = YES;	
	NSArray *buttonNames = [[NSArray alloc] initWithObjects:@"continue", @"end", nil];
	retroAlert = [[PERetroAlert alloc] initWithTitle:@"pause" message:@"game paused" buttonNames:buttonNames inView:[self view]];
	[retroAlert setDelegate:self];
	[retroAlert show];
	[buttonNames release];
	buttonNames = nil;
	[timer invalidate];
}

-(void)goToBackground:(id)sender
{
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
	{
		UILocalNotification *localNotif = [[UILocalNotification alloc] init];
		if (localNotif == nil)
			return;
		[localNotif setFireDate:[NSDate date]];
		[localNotif setAlertBody:@"Game Paused"];
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
		RELEASE_TO_NIL(localNotif);

	}
}
#pragma mark - Alert Delegate

-(void)retroAlertDidSelect:(NSString *)title
{
	RELEASE_TO_NIL(retroAlert);
	if([title isEqualToString:@"continue"] || [title isEqualToString:@"go"])
	{
		if(isFirstTime == YES || time > 1)
		{	
			isFirstTime = NO;
			[self startCountDown];
		}
		else
		{
			[self startTimer];
		}
	}
	if([title isEqualToString:@"end"])
		[self dismissModalViewControllerAnimated:YES];
	isPaused = NO;
}

-(void)wormAteCandy
{
	[PEUtils playSoundFromFile:@"laser1"];
	numberOfCandy ++;
	[wormController addWormPiece];
	[self updateScoreWithPoints: time];
	
	[self resetCandy];

}
-(void)wormAteExtraCandy
{
	[PEUtils playSoundFromFile:@"laser2"];
	[extraCandy setHidden:YES];
	[wormController setExtraCandyHidden:YES];
	[self updateScoreWithPoints: time * 25];
	[flashView setHidden:NO];
	[UIView animateWithDuration: 0.35f
					 animations:^{
						 [flashView setAlpha:0];
					 }
					 completion:^(BOOL completetion){
						 [flashView setHidden:YES];
						 [flashView setAlpha:1.0];
					 }
	 ];

}
-(void)wormCrahed
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	[self endGame];
}

@end
