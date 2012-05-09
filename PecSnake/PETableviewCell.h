//
//  PETableviewCell.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/5/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PELabel.h"

@interface PETableviewCell : UITableViewCell
{
	PELabel *score;
	PELabel *speed;
	PELabel *date;
}

-(void)setScore:(NSString *)_score;
-(void)setSpeed:(NSString *)_speed;
-(void)setDate:(NSString *)_date;


@end

