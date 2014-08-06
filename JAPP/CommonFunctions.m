//
//  HelperClass.m
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "CommonFunctions.h"

@implementation CommonFunctions


+(void)setResolutionFriendlyImageNamed:(NSString*)imageName forImageView:(UIImageView*)imageView{
    if([UIScreen mainScreen].bounds.size.height == 568){
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-568",imageName]];
    }else{
        imageView.image = [UIImage imageNamed:imageName];
    }
}

+(void)setUpUIActivityIndicator{
    
}

@end
