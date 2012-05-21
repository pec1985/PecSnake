//
//  PECreditsViewController.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/20/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PELabel.h"
#import "FlurryAnalytics.h"

@interface PECreditsViewController : UIViewController

@property (retain, nonatomic) IBOutlet PELabel *leftSideLabel;
@property (retain, nonatomic) IBOutlet PELabel *rightSideLabel;
@property (retain, nonatomic) IBOutlet PELabel *pec1985;
@property (retain, nonatomic) IBOutlet PELabel *pecdev;
@property (retain, nonatomic) IBOutlet PELabel *feedback;
@end
