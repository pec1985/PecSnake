//
//  PEWormController.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/17/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PEWormController.h"
#import "PESquareView.h"

#define RELEASE_TO_NIL(x) { if (x!=nil) { [x release]; x = nil; } }

@interface PEWormController()
{
	NSMutableArray *array;
	UIView *gameRoom;
	CGFloat maxY;
	CGFloat maxX;
}
@end

@implementation PEWormController
@synthesize delegate;
@synthesize extraCandyCenter;
@synthesize candyCenter;
@synthesize extraCandyHidden;

- (void)dealloc
{
	RELEASE_TO_NIL(array);
	RELEASE_TO_NIL(gameRoom);
    [super dealloc];
}

-(id)initWithParentView:(UIView *)view
{
	if(self = [super init])
	{
		array = [[NSMutableArray alloc] init];
		gameRoom = [view retain];
		maxX = gameRoom.frame.size.width - 5;
		maxY = gameRoom.frame.size.height - 5;
	}
	return self;
}

-(PESquareView *)newWormPiece
{
	PESquareView *a = [[PESquareView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	[a setBackgroundColor:[UIColor blueColor]];
	return [a autorelease];
}

-(void)createWormWithLength:(NSInteger)num
{
	CGPoint center = CGPointMake( ((arc4random()%29)*10)+5, ((arc4random()%39)*10)+5);
	for(int i = 0; i < num; i++)
	{
		PESquareView *sq = [self newWormPiece];
		[sq setCenter:center];
		[array addObject:sq];
		[gameRoom addSubview:sq];
		center.x -= 10;
	}
}

-(void)repositionArrayAtPoint:(CGPoint)pt
{
	PESquareView *lastWorm = [array lastObject];
	[lastWorm setCenter:pt];
	[array removeObject:lastWorm];
	[array insertObject:lastWorm atIndex:0];
	CGPoint point = [lastWorm center];
	for(PESquareView *w in array)
	{
		if([lastWorm isEqual:w] == NO && CGPointEqualToPoint([w center], point))
		{
			[delegate wormCrahed];
			return;
		}	
	}
	if(CGPointEqualToPoint(candyCenter, [lastWorm center]))
	{
		[delegate wormAteCandy];
	}
	
	if(extraCandyHidden == NO && CGPointEqualToPoint(extraCandyCenter, [lastWorm center]))
	{
		[delegate wormAteExtraCandy];
	}
}

-(void)addWormPiece
{
	PESquareView *first = [array lastObject];
	CGPoint center = [first center];
	
	PESquareView *newSquare = [[self newWormPiece] retain];
	[newSquare setCenter:center];
	[array addObject:newSquare];
	[gameRoom addSubview:newSquare];
	
	[newSquare release];
}

-(void)moveLeft
{
	PESquareView *firstWorm = [array objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.x -= 10;	
	if(point.x == -5) point.x = maxX;
	[self repositionArrayAtPoint:point];
	
}
-(void)moveRight
{
	PESquareView *firstWorm = [array objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.x += 10;
	if(point.x == maxX+10) point.x = 5;
	[self repositionArrayAtPoint:point];
}
-(void)moveUp
{
	PESquareView *firstWorm = [array objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.y -= 10;
	if(point.y == -5) point.y = maxY;
	[self repositionArrayAtPoint:point];
}
-(void)moveDown
{
	PESquareView *firstWorm = [array objectAtIndex:0];
	CGPoint point = [firstWorm center];
	point.y += 10;
	if(point.y == maxY+10) point.y = 5;
	[self repositionArrayAtPoint:point];
}

-(NSArray *)wormArray
{
	return array;
}

@end
