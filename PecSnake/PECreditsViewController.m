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
//	[pecdev setTextAlignment:UITextAlignmentRight];
//	[pec1985 setTextAlignment:UITextAlignmentRight];
	[pecdev setTextColor:[PEUtils webColor:@"#00CCFF"]];
	[pec1985 setTextColor:[PEUtils webColor:@"#00CCFF"]];
//	[feedback setTextAlignment:UITextAlignmentLeft]; 
	
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

}

- (void)viewDidUnload
{
	[self setLeftSideLabel:nil];
	[self setRightSideLabel:nil];
	[self setPec1985:nil];
	[self setPecdev:nil];
	[self setFeedback:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)closeWindow:(id)sender {
//	[textArea selectAll];
//	NSLog(@"%@", [textArea _showTextStyleOptions]);
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)pec1985Click:(id)sender
{
	[PEUtils openTwitterWithName:@"pec1985"];
	//[FlurryAnalytics logEvent:@"Clicked_on_pec1985"];
}
- (IBAction)pecdevClick:(id)sender
{
	[PEUtils openTwitterWithName:@"pecdev"];
	//[FlurryAnalytics logEvent:@"Clicked_on_pecdev"];
}

- (void)dealloc {
	[leftSideLabel release];
	[rightSideLabel release];
	[pec1985 release];
	[pecdev release];
	[feedback release];
	[super dealloc];
}
@end
