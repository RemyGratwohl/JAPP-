//
//  LocationItem.m
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "LocationItem.h"
#import "NSString+HTML.h"

@implementation LocationItem

- (NSString *)description {
    return [NSString stringWithFormat: @"\nName: %@ \nID: %@ \nIsGlobal: %hhu \nAddress1: %@ \nAddress2: %@ \nPostalCode: %@ \nPlace: %@ \nCountry: %@ \nPhone: %@ \nFax: %@\nEmail: %@ \nType: %@ \nPosX: %d \nPosY: %d \nSiteURL:%@ \nHours: %@", self.name,self.ID,self.isGlobal,self.address1,self.address2,self.postalCode,self.place,self.country,self.phoneNumber,self.fax,self.email,self.type,self.posX,self.posY,self.siteURL,self.hoursOfOperation];
}

@end
