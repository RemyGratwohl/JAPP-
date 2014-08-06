//
//  LocationItem.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "BaseItem.h"

@interface LocationItem : BaseItem

@property NSString *address1;
@property NSString *address2;
@property NSString *postalCode;
@property NSString *place;
@property NSString *country;
@property NSString *phoneNumber;
@property NSString *fax;
@property NSString *email;
@property NSString *siteURL;
@property NSString *mapURL;
@property NSString *facebookURL;
@property NSString *type;
@property NSString *hoursOfOperation;

@property int posX;
@property int posY;

@property Boolean isGlobal;

-(NSString*)description;

@end