//
//  PEMainMenu.m
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import "PEMainMenu.h"
#import "PEGameViewController.h"
#import "PEScoreViewController.h"
#import "PECreditsViewController.h"

@implementation PEMainMenu
@synthesize scoresButton;
@synthesize creditsButton;
@synthesize startGameButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[startGameButton setText:NSLocalizedString(@"start game", nil)];
	[scoresButton setText:NSLocalizedString(@"scores", nil)];
	
	UITapGestureRecognizer *_gameStart = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGame:)];
	UITapGestureRecognizer *_gameCredits = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameCredits:)];
	UITapGestureRecognizer *_gameScores = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameScores:)];
	
	[_gameStart setNumberOfTapsRequired:1];
	[_gameCredits setNumberOfTapsRequired:1];
	[_gameScores setNumberOfTapsRequired:1];
	
	[scoresButton addGestureRecognizer:_gameScores];
	[creditsButton addGestureRecognizer:_gameCredits];
	[startGameButton addGestureRecognizer:_gameStart];
	
	[_gameStart release];
	[_gameScores release];
	[_gameCredits release];
}

- (void)viewDidUnload
{
	[self setCreditsButton:nil];
	[self setStartGameButton:nil];
	[self setScoresButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)retroAlertDidSelect:(NSString *)title
{
	comingSoon = nil;
}

- (void)startGame:(id)sender {
	PEGameViewController *a = [[PEGameViewController alloc] init];
	[a setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [a setModalPresentationStyle:UIModalPresentationFullScreen];
	[a startGame];
    [self presentViewController:a animated:YES completion:nil];
	[a release];
}
- (void)gameCredits:(id)sender {
	PECreditsViewController *a = [[PECreditsViewController alloc] init];
	[a setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [a setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:a animated:YES completion:nil];
	[a release];

}
- (void)gameScores:(id)sender {
	PEScoreViewController *a = [[PEScoreViewController alloc] init];
	[a setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [a setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:a animated:YES completion:nil];
	[a release];
}

- (void)dealloc {
	[creditsButton release];
	[startGameButton release];
	[scoresButton release];
	[super dealloc];
}
@end
