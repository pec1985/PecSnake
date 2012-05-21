//
//  NSObject+PERetroAlert.h
//  Simulator Game
//
//  Created by Pedro Enrique on 4/30/12.
//  Copyright (c) 2012 - pec1985.
//

#import <QuartzCore/QuartzCore.h>
#import "PEButton.h"
#import "PEUtils.h"

@protocol PERetroAlertDelegate <NSObject>

-(void)retroAlertDidSelect:(NSString*)title;

@end

@interface PERetroAlert : NSObject
{
//	NSObject <PERetroAlertDelegate> *delegate;

}

-(id)initWithTitle:(NSString *)title message:(NSString *)msg buttonNames:(NSArray *)buttons inView:(UIView *)view;
-(void)showWithNoSound;
-(void)show;
-(void)hide;

@property(nonatomic, assign) NSObject<PERetroAlertDelegate> *delegate;
@end
