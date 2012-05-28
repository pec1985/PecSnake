//
//  PEScoreViewController.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/4/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PETableviewCell.h"
#import "PEUtils.h"
#import "PELabel.h"

@interface PEScoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet PELabel *hightScores;
@end
