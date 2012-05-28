//
//  PEMainMenu.h
//  Simulator Game
//
//  Created by Pedro Enrique on 5/2/12.
//  Copyright (c) 2012 - pec1985.
//

#import <UIKit/UIKit.h>
#import "PERetroAlert.h"

@interface PEMainMenu : UIViewController<PERetroAlertDelegate>
{
	PERetroAlert *comingSoon;
}
@property (retain, nonatomic) IBOutlet PEButton *scoresButton;
@property (retain, nonatomic) IBOutlet PEButton *creditsButton;
@property (retain, nonatomic) IBOutlet PEButton *startGameButton;
@end
