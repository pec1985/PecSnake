//
//  PEGameViewController.h
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import <UIKit/UIKit.h>
#import "PESquareView.h"
#import "PELabel.h"
#import "PERetroAlert.h"

@interface PEGameViewController : UIViewController<PERetroAlertDelegate>

@property (retain, nonatomic) IBOutlet PESquareView *scoreView;
@property (retain, nonatomic) IBOutlet PELabel *scoreLabel;
@property (retain, nonatomic) IBOutlet PELabel *speedLabel;
@property (retain, nonatomic) IBOutlet PESquareView *gameRoom;
@property (retain, nonatomic) IBOutlet PELabel *pause;

-(void)startGame;

@end