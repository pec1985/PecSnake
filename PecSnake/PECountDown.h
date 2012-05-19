//
//  PECountDown.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/19/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol PECountDownDelegate <NSObject>
@required
-(void)countDownDidFinish;
@optional
-(void)countDownChanged:(NSInteger)number;
@end

@interface PECountDown : NSObject

@property(nonatomic, assign)NSObject<PECountDownDelegate> *delegate;

-(id)initWithCountDown:(NSInteger)number inView:(UIView *)view;
-(void)startCountDown;

@end
