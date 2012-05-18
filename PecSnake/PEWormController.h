//
//  PEWormController.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/17/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PEWormControllerDelegate <NSObject>
@required
-(void)wormAteExtraCandy;
-(void)wormAteCandy;
-(void)wormCrahed;

@end


@interface PEWormController : NSObject


@property(nonatomic, assign) NSObject<PEWormControllerDelegate> *delegate;

@property(nonatomic)CGPoint extraCandyCenter;
@property(nonatomic)CGPoint candyCenter;
@property(nonatomic)BOOL extraCandyHidden;

-(void)addWormPiece;
-(id)initWithParentView:(UIView *)view;
-(void)createWormWithLength:(NSInteger)num;

-(void)moveLeft;
-(void)moveRight;
-(void)moveUp;
-(void)moveDown;

-(NSArray *)wormArray;

@end
