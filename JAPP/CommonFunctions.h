//
//  HelperClass.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface CommonFunctions : NSObject

+(void)setResolutionFriendlyImageNamed:(NSString*)imageName forImageView:(UIImageView*)imageView;
+(ItemType)itemTypeFromString:(NSString*)string;

@end

