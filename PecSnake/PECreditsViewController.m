//
//  PECreditsViewController.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/20/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PECreditsViewController.h"
#import "PEUtils.h"

@interface PECreditsViewController ()

@end

@implementation PECreditsViewController
@synthesize leftSideLabel;
@synthesize rightSideLabel;
@synthesize pec1985;
@synthesize pecdev;
@synthesize feedback;
@synthesize titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[pecdev setTextColor:[PEUtils webColor:@"#00CCFF"]];
	[pec1985 setTextColor:[PEUtils webColor:@"#00CCFF"]];
	
	[leftSideLabel setTextAlignment:UITextAlignmentLeft];
	[rightSideLabel setTextAlignment:UITextAlignmentRight];
	[leftSideLabel setBackgroundColor:[UIColor clearColor]];
	[rightSideLabel setBackgroundColor:[UIColor clearColor]];
	[leftSideLabel setText:
		@"created by:"
		@"\n\n"
		@"designed by:"
		@"\n\n"
		@"brains:"
		@"\n\n"
		@"idea:"
		@"\n\n"
		@"inspiration:"
	 
	 ];
	[rightSideLabel setText:
		@"@pec1985"
		@"\n\n"
		@"@pec1985"
		@"\n\n"
		@"@pec1985"
		@"\n\n"
		@"@pecdev"
		@"\n\n"
		@"@pecdev"	 
	 ];

	UITapGestureRecognizer *closeView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow:)];
	UITapGestureRecognizer *openPec1985 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pec1985Click:)];
	UITapGestureRecognizer *openPecDev = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pecdevClick:)];
	
	[closeView setNumberOfTapsRequired:1];
	[openPecDev setNumberOfTapsRequired:1];
	[openPec1985 setNumberOfTapsRequired:1];
	
	[pecdev addGestureRecognizer:openPecDev];
	[pec1985 addGestureRecognizer:openPec1985];
	[titleLabel addGestureRecognizer:closeView];
	
	[openPecDev release];
	[openPec1985 release];
	[closeView release];
	
}

- (void)viewDidUnload
{
	[self setLeftSideLabel:nil];
	[self setRightSideLabel:nil];
	[self setPec1985:nil];
	[self setPecdev:nil];
	[self setFeedback:nil];
	[self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)closeWindow:(id)sender {
//	[textArea selectAll];
//	NSLog(@"%@", [textArea _showTextStyleOptions]);
	[self dismissModalViewControllerAnimated:YES];
}


- (void)pec1985Click:(id)sender
{
	[PEUtils openTwitterWithName:@"pec1985"];
	[FlurryAnalytics logEvent:@"Clicked_on_pec1985"];
}
- (void)pecdevClick:(id)sender
{
	[PEUtils openTwitterWithName:@"pecdev"];
	[FlurryAnalytics logEvent:@"Clicked_on_pecdev"];
}

- (void)dealloc {
	[leftSideLabel release];
	[rightSideLabel release];
	[pec1985 release];
	[pecdev release];
	[feedback release];
	[titleLabel release];
	[super dealloc];
}
@end
