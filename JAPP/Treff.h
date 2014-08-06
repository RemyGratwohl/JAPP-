//
//  Treff.h
//  JAPP
//
//  Created by Remy Gratwohl on 24/06/14.
//
//

#import <Foundation/Foundation.h>

@interface Treff : NSObject

@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *city;

@property(strong,nonatomic)NSURL *bannerImageURL;
@property(strong,nonatomic)NSString *phoneNumber;




@property(strong,nonatomic)NSURL *websiteURL;
@property(strong,nonatomic)NSURL *telephoneNumber;
@property(strong,nonatomic)NSURL *facebookPage;

@end
