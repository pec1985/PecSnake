//
//  PEScores.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/13/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEScores : NSObject

@property (nonatomic) int score;

-(void)addScore:(int)_score;

@end
