//
//  Event.h
//  JAPP
//
//  Created by Remy Gratwohl on 25/06/14.
//
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *date;
@property(strong,nonatomic)NSString *time;
@property(strong,nonatomic)NSString *location;
@property(strong,nonatomic)NSString *description;

@property(strong,nonatomic)NSString *websiteURL;

@end
