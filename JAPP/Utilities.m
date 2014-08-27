//
//  HelperClass.m
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "Utilities.h"

@implementation Utilities


+(void)setResolutionFriendlyImageNamed:(NSString*)imageName forImageView:(UIImageView*)imageView{
    
    if(IS_IPHONE_SERIES_5){
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-568",imageName]];
    }else if (IS_IPHONE_SERIES_4){
        imageView.image = [UIImage imageNamed:imageName];
    }else{
        NSLog(@"Unable to set image. Unrecognized screen size");
    }
}

+(ItemType)itemTypeFromString:(NSString*)string{
    if([string isEqualToString:@"Location"]){
        return LOCATION;
    }else if([string isEqualToString:@"Event"]){
        return EVENT;
    }else if([string isEqualToString:@"Post"]){
        return NEWS;
    }else{
        NSLog(@"Unable to Convert String:\"%@\" to an ItemType",string);
        return -1;
    }
}

+(NSString*)germanMonthFromNumber:(int) num{
    
    NSArray *monats = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mär",@"Apr",@"Mai",@"Jun",@"Jul",@"Aug",@"Sep",@"Okt",@"Nov",@"Dez", nil];
    
    return [monats objectAtIndex:num];
}

@end
