//
//  PEGameViewController.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PEGameViewController.h"
#import "TiWebColor.h"
#import "PEScores.h"

typedef enum {
	WormDirectionLeft,
	WormDirectionRight,
	WormDirectionTop,
	WormDirectionBottom
} WormDirection;

static NSString *PAUSE_EVENT = @"pause";

#define RELEASE_TO_NIL(x) { if (x!=nil) { [x release]; x = nil; } }


@interface PEGameViewController ()
{
@private
	NSMutableArray *wormArray;
	WormDirection direction;
	NSTimer *timer;
	NSTimer *showExtraCandyTimer;
//	NSTimer *hideExtraCandyTimer;
	NSTimeInterval interVal;
	UIView *board1;
	UIView *board2;
	UIColor *boardColor;
	UIColor *boardMargin;
	PEScores *finalScore;
	PESquareView *candy;
	PESquareView *extraCandy;
	PERetroAlert *retroAlert;
	CGFloat maxY;
	CGFloat maxX;
	NSInteger numberOfCandy;
	int time;
	int currentScore;
	int extraScore;
	BOOL isPaused;
}

-(void)resetCandy;
-(UIView *)candy;
-(PESquareView *)extraCandy;
-(void)addWormPiece;
-(void)extraCandyTimers;

@end

@implementation PEGameViewController
@synthesize scoreView;
@synthesize scoreLabel;
@synthesize gameRoom;
@synthesize pause;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		direction = WormDirectionRight;
		wormArray = [[NSMutableArray alloc] init];
		numberOfCandy = 0;
		interVal = 0.1f;
		time = 1;
		currentScore = 0;
		extraScore = 0;
		isPaused = NO;
    }
    return self;
}

#pragma mark - View Controller Stuff

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	finalScore = [[PEScores alloc] init];
	[[self view] setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[pause sizeToFit];
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: 0    SPEED:  1"]];
	[scoreLabel setTextAlignment:UITextAlignmentLeft];
	[scoreView setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[scoreLabel setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[pause setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	
	maxX = gameRoom.frame.size.width - 5;
	maxY = gameRoom.frame.size.height - 5;
	
	[self createWormWithLength:1];
	[self resetCandy];
	extraCandy = [self extraCandy];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseClicked:) name:PAUSE_EVENT object:nil];
	
	
}

- (void)viewDidUnload
{
	[self setScoreView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
	NSLog(@"dealloc");
	for(UIView *v in wormArray)
		[v removeFromSuperview];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[wormArray removeAllObjects];
	RELEASE_TO_NIL(finalScore);
	RELEASE_TO_NIL(extraCandy);	
	RELEASE_TO_NIL(wormArray);
	RELEASE_TO_NIL(candy);
	RELEASE_TO_NIL(gameRoom);	
	RELEASE_TO_NIL(scoreLabel)
	RELEASE_TO_NIL(pause)
	RELEASE_TO_NIL(scoreView)
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
	[showExtraCandyTimer invalidate];
//	[hideExtraCandyTimer invalidate];
	retroAlert = [[PERetroAlert alloc] initWithTitle:@"game over" message:@"HA HA! Sucker!" buttonNames:[NSArray arrayWithObject:@"end"] inView:[self view]];
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

-(void)repositionArrayAtPoint:(CGPoint)pt
{
	PESquareView *lastWorm = [wormArray lastObject];
	//	[UIView animateWithDuration:0.2 animations:^{
	[lastWorm setCenter:pt];
	//	}];
	[wormArray removeObject:lastWorm];
	[wormArray insertObject:lastWorm atIndex:0];
	CGPoint point = [lastWorm center];
	for(PESquareView *w in wormArray)
	{
		if([lastWorm isEqual:w] == NO && CGPointEqualToPoint([w center], point))
		{
			[self endGame];
			return;
		}	
	}
	if(CGPointEqualToPoint([[self candy] center], [lastWorm center]))
	{
		numberOfCandy ++;
		[self addWormPiece];
		[self resetCandy];
	}
	
	if([extraCandy isHidden] == NO && CGPointEqualToPoint([extraCandy center], [lastWorm center]))
	{
		[extraCandy setHidden:YES];
		NSLog(@"%f",[extraCandy alpha] * 100);
		[self updateScoreWithPoints: 100];
	}
	
}

-(void)moveLeft
{
	PESquareView *firstWorm = [wormArray objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.x -= 10;	
	if(point.x == -5) point.x = maxX;
	[self repositionArrayAtPoint:point];
	
}
-(void)moveRight
{
	PESquareView *firstWorm = [wormArray objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.x += 10;
	if(point.x == maxX+10) point.x = 5;
	[self repositionArrayAtPoint:point];
}
-(void)moveTop
{
	PESquareView *firstWorm = [wormArray objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.y -= 10;
	if(point.y == -5) point.y = maxY;
	[self repositionArrayAtPoint:point];
}
-(void)moveBottom
{
	PESquareView *firstWorm = [wormArray objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.y += 10;
	if(point.y == maxY+10) point.y = 5;
	[self repositionArrayAtPoint:point];
}


-(void)moveWorm
{
	switch (direction) {
		case WormDirectionLeft:
    		[self moveLeft];
    		break;
		case WormDirectionRight:
			[self moveRight];
			break;
		case WormDirectionTop:
			[self moveTop];
			break;
		case WormDirectionBottom:
			[self moveBottom];
			break;
	}
}

#pragma mark - Worm Stuff

-(void)addWormPiece
{
	PESquareView *first = [wormArray lastObject];
	CGPoint center = [first center];
	
	PESquareView *newSquare = [[self wormPiece] retain];
	[newSquare setCenter:center];
	[wormArray addObject:newSquare];
	[gameRoom addSubview:newSquare];
	
	[newSquare release];
	[self updateScoreWithPoints: time];
}

-(void)createWormWithLength:(NSInteger)num
{
	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
	for(int i = 0; i < num; i++)
	{
		PESquareView *sq = [self wormPiece];
		[sq setCenter:center];
		[wormArray addObject:sq];
		[gameRoom addSubview:sq];
		center.x -= 10;
	}
}

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
		[extraCandy setBackgroundColor:[UIColor greenColor]];
		[extraCandy setHidden:YES];
		[gameRoom addSubview:extraCandy];
	}
	
	[self resetExtraCandy];
	[self extraCandyTimers];
	return extraCandy;
}

-(PESquareView *)wormPiece
{
	PESquareView *a = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	[a setBackgroundColor:[UIColor blueColor]];
	return [a autorelease];
}


#pragma mark - Game Timers

-(void)extraCandyTimers
{
	if(showExtraCandyTimer && [showExtraCandyTimer isValid])
		[showExtraCandyTimer invalidate];
//	if(hideExtraCandyTimer && [hideExtraCandyTimer isValid])
//		[hideExtraCandyTimer invalidate];
	
	showExtraCandyTimer = [[NSTimer scheduledTimerWithTimeInterval: 10.0
															target: self
														  selector: @selector(showExtraCandy:)
														  userInfo: self
														   repeats: YES] retain];
//	hideExtraCandyTimer = [[NSTimer scheduledTimerWithTimeInterval: 5.0/2
//															target: self
//														  selector: @selector(hideExtraCandy:)
//														  userInfo: self
//														   repeats: YES] retain];
}

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
	for(PESquareView *w in wormArray)
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
}


-(void)hideExtraCandy:(id)sender
{
//	NSLog(@"hideExtraCandy");
//	[extraCandy setHidden:YES];
}

-(void)showExtraCandy:(id)sender
{
//	NSLog(@"showExtraCandy");
	[extraCandy setHidden:NO];
	
	[UIView animateWithDuration: 5.0
					 animations:^{
						 [extraCandy setAlpha:0.25];
					 }
					 completion:^(BOOL complete){
						 [extraCandy setAlpha:1.0];
//						 [extraCandy setBackgroundColor:[UIColor greenColor]];
						 [extraCandy setHidden:YES];
					 }
	 ];

	
	[self resetExtraCandy];
}

#pragma mark - Normal Candy Stuff

-(void)resetCandy
{
	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
	for(PESquareView *w in wormArray)
	{
		if(CGPointEqualToPoint(center, [w center]))
		{
			[self resetCandy];
			return;
		}
	}
	[[self candy] setCenter:center];
	if(numberOfCandy == 5)
	{
		numberOfCandy = 0;
		interVal -= 0.005f;
		time++;
		[timer invalidate];
		[self startTimer];
	}
}

#pragma mark - Scores And Points

-(void)updateScoreWithPoints:(int)points
{
	
	[finalScore addScore: points];	
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i    SPEED: %i", [finalScore score], time]];
	
}

#pragma mark - User Actions

- (IBAction)swipeLeft:(id)sender {
	if(direction != WormDirectionRight)
		direction = WormDirectionLeft;
}

- (IBAction)swipeRight:(id)sender {
	if(direction != WormDirectionLeft)
		direction = WormDirectionRight;
}
- (IBAction)swipeUp:(id)sender {
	if(direction != WormDirectionBottom)
		direction = WormDirectionTop;
}

- (IBAction)swipeDown:(id)sender {
	if(direction != WormDirectionTop)
		direction = WormDirectionBottom;
}

-(IBAction)pauseClicked:(id)sender
{
	if(isPaused) return;
	isPaused = YES;	
	NSArray *buttonNames = [[NSArray alloc] initWithObjects:@"continue", @"end", nil];
	retroAlert = [[PERetroAlert alloc] initWithTitle:@"pause" message:@"game paused" buttonNames:buttonNames inView:[self view]];
	[retroAlert setDelegate:self];
	[retroAlert show];
	[buttonNames release];
	buttonNames = nil;
	[timer invalidate];
	[showExtraCandyTimer invalidate];
//	[hideExtraCandyTimer invalidate];
}

#pragma mark - Alert Delegate

-(void)retroAlertDidSelect:(NSString *)title
{
	RELEASE_TO_NIL(retroAlert);
	if([title isEqualToString:@"continue"] || [title isEqualToString:@"go"])
	{
		[self startTimer];
		[self extraCandyTimers];
	}
	if([title isEqualToString:@"end"])
		[self dismissModalViewControllerAnimated:YES];
	isPaused = NO;
}

@end



/*
 
 - (void)swipeLeft
 {
 if(direction != WormDirectionRight)
 direction = WormDirectionLeft;
 }
 
 - (void)swipeRight
 {
 if(direction != WormDirectionLeft)
 direction = WormDirectionRight;
 }
 - (void)swipeUp
 {
 if(direction != WormDirectionBottom)
 direction = WormDirectionTop;
 }
 
 - (void)swipeDown
 {
 if(direction != WormDirectionTop)
 direction = WormDirectionBottom;
 }
 
 - (IBAction)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
 
 CGPoint sPoint = [gestureRecognizer translationInView:[gestureRecognizer view]];
 
 WormDirection _direction;
 
 CGPoint newPoint = CGPointMake(currentPoint.x-sPoint.x, currentPoint.y-sPoint.y);
 
 if(newPoint.y > newPoint.x && newPoint.y > 10)
 {
 _direction = WormDirectionTop;	
 } else
 
 if(newPoint.y > newPoint.x && newPoint.x < -10)
 {
 _direction = WormDirectionRight;
 } else
 
 if(newPoint.y < newPoint.x && newPoint.y < -10)
 {
 _direction = WormDirectionBottom;
 } else
 
 if(newPoint.y < newPoint.x && newPoint.x > 10)
 {
 _direction = WormDirectionLeft;
 }
 currentPoint = sPoint;
 
 
 
 switch (_direction) {
 case WormDirectionTop:
 [pause setText:@"Top"];
 [self swipeUp];
 break;
 case WormDirectionRight:
 [pause setText:@"Right"];
 [self swipeRight];
 break;
 case WormDirectionBottom:
 [pause setText:@"Bottom"];
 [self swipeDown];
 break;
 case WormDirectionLeft:
 [pause setText:@"Left"];
 [self swipeLeft];
 break;
 }
 
 }
 
 
 */
