//
//  PECreditsViewController.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/20/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PELabel.h"

@interface PECreditsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textArea;
@property (retain, nonatomic) IBOutlet PELabel *leftSideLabel;
@property (retain, nonatomic) IBOutlet PELabel *rightSideLabel;
@end
