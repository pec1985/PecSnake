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

@implementation PEMainMenu

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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

- (IBAction)startGame:(id)sender {
	PEGameViewController *a = [[PEGameViewController alloc] init];
	[a setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[a startGame];
	[self presentViewController:a animated:YES completion:^{
		[a autorelease];
	}];
}
- (IBAction)gameCredits:(id)sender {
	comingSoon = [[PERetroAlert alloc] initWithTitle:@"coming soon" message:@"meh" buttonNames:[NSArray arrayWithObject:@"ok"] inView:[self view]];
	[comingSoon setDelegate:self];
	[comingSoon show];
}
- (IBAction)gameScores:(id)sender {
	PEScoreViewController *a = [[PEScoreViewController alloc] init];
	[a setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentViewController:a animated:YES completion:^{
		[a autorelease];
	}];
}

@end
