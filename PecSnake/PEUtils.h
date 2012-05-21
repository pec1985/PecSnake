//
//  PEUtils.h
//  PecSnake
//
//  Created by Pedro Enrique on 5/19/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import "TiWebColor.h"

@interface PEUtils : NSObject


+(void)playSoundFromFile:(NSString *)url;
+(UIFont *)awesomeFont;
+(void)openTwitterWithName:(NSString *)twitterName;
+(UIColor *)webColor:(NSString *)color;

@end
