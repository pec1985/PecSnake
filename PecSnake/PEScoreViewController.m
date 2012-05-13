//
//  PEScoreViewController.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/4/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PEScoreViewController.h"
#import "PETableviewCell.h"
#import "TiWebColor.h"

@interface PEScoreViewController ()
{
	NSArray *allData;
	UIView *headerView;
}
@end

@implementation PEScoreViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[table setAllowsSelection:NO];
	NSMutableArray *temp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"game_scores"] mutableCopy];	
	NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
	
	[temp sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];
	
	allData = [temp copy];
	[[self table] setDataSource:self];
	[[self table] setDelegate:self];
	[[self table] reloadData];
	[temp release];
	[mySorter release];
}

- (void)viewDidUnload
{
	[self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [allData count] > 20 ? 20 : [allData count];
}

-(PETableviewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PETableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scores_cell"];
	if(cell == nil)
	{
		cell = [[[PETableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scores_cell"] autorelease];
	}
	
	[cell setScore:[NSString stringWithFormat: @"%@", [[allData objectAtIndex:[indexPath row]] valueForKey:@"score"]]];
	[cell setSpeed:[NSString stringWithFormat: @"%@", [[allData objectAtIndex:[indexPath row]] valueForKey:@"time"]]];
	[cell setDate:[NSString stringWithFormat: @"%@", [[allData objectAtIndex:[indexPath row]] valueForKey:@"date"]]];
	
	return cell;
}

-(UIView*)headerView
{
	if(headerView == nil)
	{
		
		PELabel *date = [[PELabel alloc] init];
		PELabel *score = [[PELabel alloc] init];
		PELabel *speed = [[PELabel alloc] init];

		[date setText:@"date"];
		[score setText:@"score"];
		[speed setText:@"speed"];
		
		UIColor *_color = [TiWebColor webColorNamed:@"#333"];
		[date setBackgroundColor:_color];
		[score setBackgroundColor:_color];
		[speed setBackgroundColor:_color];

		CGRect contentFrame = [[self table] bounds];
		
		contentFrame.size.height = 30.0f	;
		
		headerView = [[UIView alloc] initWithFrame:contentFrame];
		[headerView setBackgroundColor:_color];
		contentFrame.origin.x = 0;
		contentFrame.size.width = 100;
		[date setFrame:contentFrame];
		
		contentFrame.origin.x += 100;
		contentFrame.size.width = 90;
		[score setFrame:contentFrame];
		
		contentFrame.origin.x += 90;
		contentFrame.size.width = 90;
		[speed setFrame:contentFrame];
		
		[headerView addSubview:date];
		[headerView addSubview:score];
		[headerView addSubview:speed];
		[date release];
		[score release];
		[speed release];
	}
	return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return [self headerView];
}

-(IBAction)closeViewController:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[allData release];
	[headerView release];
	[table release];
	[super dealloc];
}
@end
