//
//  HelperClass.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface Utilities : NSObject

+(void)setResolutionFriendlyImageNamed:(NSString*)imageName forImageView:(UIImageView*)imageView;
+(ItemType)itemTypeFromString:(NSString*)string;
+(NSString*)germanMonthFromNumber:(int) num;

@end

