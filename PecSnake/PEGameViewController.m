//
//  PEGameViewController.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PEGameViewController.h"
#import "TiWebColor.h"

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
	UIView *board1;
	UIView *board2;
	UIColor *boardColor;
	UIColor *boardMargin;
	UIView *candy;
	NSInteger numberOfCandy;
	NSTimeInterval interVal;
	PERetroAlert *retroAlert;
	CGFloat maxY;
	CGFloat maxX;
	int time;
	int currentScore;
	BOOL isPaused;
}

-(void)resetCandy;
-(UIView *)candy;
-(void)addWormPiece;

@end

@implementation PEGameViewController
@synthesize scoreView;
@synthesize scoreLabel;
@synthesize speedLabel;
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
		isPaused = NO;
    }
    return self;
}

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
			[timer invalidate];
			retroAlert = [[PERetroAlert alloc] initWithTitle:@"game over" message:@"HA HA! Sucker!" buttonNames:[NSArray arrayWithObject:@"end"] inView:[self view]];
			[retroAlert setDelegate:self];
			[retroAlert show];
			isPaused = YES;	
			currentScore--;
			
			NSUserDefaults *urs = [NSUserDefaults standardUserDefaults];
			
			NSMutableArray *ar = [[urs objectForKey:@"game_scores"] mutableCopy];
			if(!ar)
				ar = [[NSMutableArray alloc] init];

			NSDate *localDate = [NSDate date];
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
			[dateFormatter setDateFormat: @"MM-dd-yy"];
			NSString *dateString = [dateFormatter stringFromDate: localDate];

			NSDictionary *sc = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:time*currentScore],@"score",[NSNumber numberWithInt:time],@"time", dateString, @"date", nil];
			
			[ar addObject:sc];
			
			[urs setObject:ar forKey:@"game_scores"];
			[urs synchronize];
			[ar release];
			break;
		}	
	}
	if(CGPointEqualToPoint([[self candy] center], [lastWorm center]))
	{
		numberOfCandy ++;
		[self addWormPiece];
		[self resetCandy];
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

-(UIView *)candy
{
	if(candy == nil)
	{
		candy = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		[candy setBackgroundColor:[UIColor redColor]];
		[gameRoom addSubview:candy];
	}
	return candy;
}

-(void)startTimer
{
	if(timer && [timer isValid])
		[timer invalidate];
	timer = [[NSTimer scheduledTimerWithTimeInterval:interVal target: self selector:@selector(moveWorm) userInfo:self repeats:true] retain];
}

-(PESquareView *)wormPiece
{
	PESquareView *a = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	[a setBackgroundColor:[UIColor blueColor]];
	return [a autorelease];
}

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


-(void)addWormPiece
{
	PESquareView *first = [wormArray lastObject];
	CGPoint center = [first center];
	
	PESquareView *newSquare = [[self wormPiece] retain];
	[newSquare setCenter:center];
	[wormArray addObject:newSquare];
	[gameRoom addSubview:newSquare];
	
	[newSquare release];

	if(currentScore == 0)
		currentScore = [wormArray count];
			
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", (time*currentScore)]];
	[speedLabel setText:[NSString stringWithFormat:@"SPEED: %i", time]];
	[speedLabel sizeToFit];
	[scoreLabel sizeToFit];
	
	CGRect scoreFrame = [scoreLabel frame];
	CGRect speedFrame = [speedLabel frame];
	speedFrame.origin.x = scoreFrame.origin.x+scoreFrame.size.width+10;
	[speedLabel setFrame:speedFrame];
	currentScore ++;
}

-(void)createWormWithLength:(NSInteger)num
{

	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
///	CGPoint center = CGPointMake(5,5);
	for(int i = 0; i < num; i++)
	{
		PESquareView *sq = [self wormPiece];
		[sq setCenter:center];
		[wormArray addObject:sq];
		[gameRoom addSubview:sq];
		center.x -= 10;
	}
}

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

-(void)retroAlertDidSelect:(NSString *)title
{
	RELEASE_TO_NIL(retroAlert);
	if([title isEqualToString:@"continue"] || [title isEqualToString:@"go"])
		[self startTimer];
	if([title isEqualToString:@"end"])
		[self dismissModalViewControllerAnimated:YES];
	isPaused = NO;
	
}

-(void)pauseClicked
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[[self view] setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[pause sizeToFit];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseClicked)];
	[scoreView addGestureRecognizer:tapGesture];
	[scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", 0]];
	[speedLabel setText:[NSString stringWithFormat:@"SPEED: %i", 1]];
	[speedLabel sizeToFit];
	[scoreLabel sizeToFit];

	[scoreView setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[speedLabel setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[scoreLabel setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];
	[pause setBackgroundColor:[TiWebColor webColorNamed:@"#333"]];

	
	[tapGesture release];
	
	CGRect scoreFrame = [scoreLabel frame];
	CGRect speedFrame = [speedLabel frame];
	speedFrame.origin.x = scoreFrame.origin.x+scoreFrame.size.width+10;
	[speedLabel setFrame:speedFrame];
	
	maxX = gameRoom.frame.size.width - 5;
	maxY = gameRoom.frame.size.height - 5;
	
	[self createWormWithLength:1];
	[self resetCandy];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseClicked) name:PAUSE_EVENT object:nil];


}

-(void)meh:(id)arg
{
	[self pause];
	NSLog(@"meh %@",arg);
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

-(void)dealloc
{
	for(UIView *v in wormArray)
		[v removeFromSuperview];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[wormArray removeAllObjects];

	RELEASE_TO_NIL(wormArray);
	RELEASE_TO_NIL(candy);
	RELEASE_TO_NIL(gameRoom);	
	RELEASE_TO_NIL(speedLabel)	
	RELEASE_TO_NIL(scoreLabel)
	RELEASE_TO_NIL(pause)
	RELEASE_TO_NIL(scoreView)
	[super dealloc];
}

@end
