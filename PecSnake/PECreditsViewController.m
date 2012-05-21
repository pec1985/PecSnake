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
@synthesize textArea;
@synthesize leftSideLabel;
@synthesize rightSideLabel;

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
	
	[textArea setFont:[PEUtils awesomeFont]];
	[textArea setEditable:NO];
	[textArea setText:
		@"feedback and contact:\n\tpecsnake@gmail.com\n"
	 ];
}

- (void)viewDidUnload
{
	[self setTextArea:nil];
	[self setLeftSideLabel:nil];
	[self setRightSideLabel:nil];
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

- (void)dealloc {
	[textArea release];
	[leftSideLabel release];
	[rightSideLabel release];
	[super dealloc];
}
@end
