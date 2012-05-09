//
//  PEScoreViewController.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/4/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEScoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *table;
@end
