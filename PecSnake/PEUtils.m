//
//  PEUtils.m
//  PecSnake
//
//  Created by Pedro Enrique on 5/19/12.
//  Copyright (c) 2012 Appcelerator. All rights reserved.
//

#import "PEUtils.h"

@implementation PEUtils

+(void)playSoundFromFile:(NSString *)url
{
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:url ofType:@"wav"];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
	AudioServicesPlaySystemSound (soundID);

}

+(UIFont *)awesomeFont
{
	return [UIFont fontWithName:@"DS-Digital" size:20];
}

+(void)openTwitterWithName:(NSString *)twitterName
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"twitter://user?screen_name=%@",twitterName]];
	BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL: url];
	
	if (canOpenURL) {
		[[UIApplication sharedApplication] openURL: url];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://twitter.com/%@",twitterName]]];
	}	
}

+(UIColor *)webColor:(NSString *)color
{
	return [TiWebColor webColorNamed:color];
}
@end
