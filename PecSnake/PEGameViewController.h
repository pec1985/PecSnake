//
//  PEGameViewController.h
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import <UIKit/UIKit.h>
#import "FlurryAnalytics.h"
#import "PEWormController.h"
#import "PESquareView.h"
#import "PERetroAlert.h"
#import "PECountDown.h"
#import "PEScores.h"
#import "PELabel.h"
#import "PEUtils.h"

@interface PEGameViewController : UIViewController<PERetroAlertDelegate, PEWormControllerDelegate, PECountDownDelegate>
{
	PECountDown *countDown;
	PEWormController *wormController;
}
@property (retain, nonatomic) IBOutlet PESquareView *scoreView;
@property (retain, nonatomic) IBOutlet PELabel *scoreLabel;
@property (retain, nonatomic) IBOutlet PESquareView *gameRoom;
@property (retain, nonatomic) IBOutlet PELabel *pause;
@property (retain, nonatomic) IBOutlet UIView *flashView;

-(void)startGame;

@end
