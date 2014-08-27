//
//  psDataManager.m
//  HuberApp
//
//  Created by Sitewalk on 30.01.14.
//  Copyright (c) 2014 Sitewalk. All rights reserved.
//

#import "ServerManager.h"
#import "psMailItem.h"
#import "Common.h"
#import "LocationItem.h"
#import "NSString+HTML.h"
#import "Utilities.h"
#import "NewsItem.h"
#import "EventItem.h"
#import "SDImageCache.h"

@interface ServerManager()
    @property ItemType type;
@end

@implementation ServerManager

static NSString *serverBaseURL = @"http://japp.14.skintest.lan/Portals/0/contortionistUniverses/397/";
static NSString *serverPersistanceURLFragment = @"editSkins/persistence.ashx";
static NSString *serverImageURLFragment = @"images/";

static NSString *imageURL = @"http://japp.14.skintest.lan/Portals/0/contortionistUniverses/397/images/";

- (id)init {
	self = [super init];
    
	if(self != nil) {
        
    }
    
    return self;
}

-(void) doLoadDataFromServerOfType: (int) ObjectType{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    
    switch (ObjectType){
        case(LOCATION):
            [request setHTTPBody: [serverLocationsQueryString dataUsingEncoding:NSASCIIStringEncoding]];
            break;
        case(EVENT):
            [request setHTTPBody: [serverEventsQueryString dataUsingEncoding:NSASCIIStringEncoding]];
            break;
        case(NEWS):

            [request setHTTPBody: [serverNewsQueryString dataUsingEncoding:NSASCIIStringEncoding]];
            break;
    }
    
    // Create url connection and fire an asychronous request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection) {
        NSLog(@"Connection to server not initalized.");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
    
    //NSString* resString =  [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    //NSLog(@"%@",resString);
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    //convert to JSONs
    NSError *myError = nil;
    NSDictionary *resJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    if(!myError){
        
        // Determine and Archive the type
        NSString *type = [self determineTypeOfJSONString:resJson];
        NSLog(@"Saving resJSON of Type:%@",type);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:type];
        
        [NSKeyedArchiver archiveRootObject:resJson toFile:filePath];

    }
    
    NSMutableArray *items = [self decodeJSONItems:resJson];
    [self.delegate didFinishLoadingItems:items ofType:self.type];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Connection to server failed: %@; %@", error.localizedDescription, error.localizedFailureReason);
}

- (NSMutableArray *) decodeJSONItems:(NSDictionary *) resJson{
    // Array of items to return
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //Search through the values
    for(id key in resJson) {
        
        id value = [resJson objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        
        if ([keyAsString isEqualToString:@"isSuccess"]) {
            // Ignore
        } else if ([keyAsString isEqualToString:@"message"]) {
            // Ignore
        } else if ([keyAsString isEqualToString:@"items"]) {
            
            NSArray *tempItems = (NSArray *)value;
            
            // For each object in items
            for (id keyValuePair in tempItems) {
                
                // Create a Dictionary of the Object's Properties
                NSDictionary *detailsDict  = (NSDictionary *) keyValuePair;
                
                // Retrieve the Type for the Appropriate Delegate Callback
                self.type = [Utilities itemTypeFromString:[detailsDict objectForKey:@"itemType"]];
                
                if(self.type == LOCATION){
                    [items addObject:[self createLocationFromDetailsDictionary:detailsDict]];
                }else if(self.type == EVENT){
                    EventItem *newEvent = [self createEventFromDetailsDictionary:detailsDict];
                    if([newEvent.endDate compare:[NSDate date]] == NSOrderedDescending){
                        [items addObject:[self createEventFromDetailsDictionary:detailsDict]];
                    }
                }else if (self.type == NEWS){
                    [items addObject:[self createNewsFromDetailsDictionary:detailsDict]];
                }
                
            }
        }
    }
    
    return items;
}

-(NSString*)determineTypeOfJSONString:(NSDictionary *) resJson{
    return [[resJson valueForKeyPath:@"items.itemType"] objectAtIndex:0];
}

-(LocationItem*)createLocationFromDetailsDictionary:(NSDictionary*)dict{
    
    LocationItem *lItem = [[LocationItem alloc] init];
    
    for(id key2 in dict) {
        
        NSString *keyString2 = (NSString *)key2;
        id value2 = [dict objectForKey:keyString2];
        
        if ([keyString2 isEqualToString:@"BOOL"]) {
            lItem.isGlobal = [[value2 objectForKey:@"isGlobal"] boolValue];
        } else if ([keyString2 isEqualToString:@"SHORT_TEXT"]) {
            lItem.name = [value2 objectForKey:@"name"];
            lItem.address1 = [value2 objectForKey:@"address1"];
            lItem.address2 = [value2 objectForKey:@"address2"];
            lItem.postalCode = [value2 objectForKey:@"postalCode"];
            lItem.place = [value2 objectForKey:@"place"];
            lItem.country = [value2 objectForKey:@"country"];
            lItem.phoneNumber = [value2 objectForKey:@"phone"];
            lItem.fax = [value2 objectForKey:@"fax"];
            lItem.email = [value2 objectForKey:@"email"];
            lItem.type = [value2 objectForKey:@"type"];
            lItem.phoneNumber = [value2 objectForKey:@"phone"];
        }else if ([keyString2 isEqualToString:@"LONG_TEXT"]) {
            lItem.descript = [[value2 objectForKey:@"description"] stringByConvertingHTMLToPlainText];
            lItem.hoursOfOperation = [[value2 objectForKey:@"hoursOfOperation"] stringByConvertingHTMLToPlainText];
        }else if ([keyString2 isEqualToString:@"HYPERLINK"]) {
            lItem.siteURL = [value2 objectForKey:@"siteUrl"];
            lItem.facebookURL = [value2 objectForKey:@"facebookUrl"];
            lItem.mapURL = [value2 objectForKey:@"mapUrl"];
            
        }else if ([keyString2 isEqualToString:@"IMAGE"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@/Location_image/%@",imageURL,[value2 objectForKey:@"image"]];
            
            UIImage *image = [self loadImageFromURLwithName:urlString];
            
            if(image){
            [[SDImageCache sharedImageCache] storeImage:image forKey:urlString];
            }
            
            lItem.imageURL = urlString;
        }else if ([keyString2 isEqualToString:@"INT"]){
            
            lItem.posX = [[value2 objectForKey:@"posX"] integerValue];
            lItem.posY = [[value2 objectForKey:@"posY"] integerValue];
            
        } else if ([keyString2 isEqualToString:@"itemId"]) {
            lItem.ID= [dict objectForKey:@"itemId"];
            
        }
        
    }
    
    return lItem;
}

-(NewsItem*)createNewsFromDetailsDictionary:(NSDictionary*)dict{
    NewsItem *newNewsItem = [[NewsItem alloc] init];
    
    for(id key2 in dict) {
        
        NSString *keyString2 = (NSString *)key2;
        id value2 = [dict objectForKey:keyString2];
        
       if ([keyString2 isEqualToString:@"SHORT_TEXT"]) {
           newNewsItem.title = [value2 objectForKey:@"title"];
        }else if ([keyString2 isEqualToString:@"LONG_TEXT"]) {
            newNewsItem.descript = [[value2 objectForKey:@"description"] stringByConvertingHTMLToPlainText];
        }else if ([keyString2 isEqualToString:@"HYPERLINK"]) {
            newNewsItem.siteURL = [value2 objectForKey:@"siteLink"];
        }else if ([keyString2 isEqualToString:@"IMAGE"]) {
            
        }else if ([keyString2 isEqualToString:@"TIMEDATE"]){
            newNewsItem.publishDate = [newNewsItem convertLongNumberToDate:[value2 objectForKey:@"publishDate"]];
            
        } else if ([keyString2 isEqualToString:@"itemId"]) {
            newNewsItem.ID= [dict objectForKey:@"itemId"];
        }else if ([keyString2 isEqualToString:@"REF_N1"]){
            NSDictionary *idDictionary = [dict objectForKey:@"REF_N1"];
            newNewsItem.clubReferenceID = [idDictionary objectForKey:@"location"];
        }
        
    }
    return newNewsItem;
}

-(EventItem*)createEventFromDetailsDictionary:(NSDictionary*)dict{
    EventItem *newEventItem = [[EventItem alloc] init];
    
    for(id key2 in dict) {
        
        NSString *keyString2 = (NSString *)key2;
        id value2 = [dict objectForKey:keyString2];
        
        if ([keyString2 isEqualToString:@"SHORT_TEXT"]) {
            newEventItem.title = [value2 objectForKey:@"title"];
        }else if ([keyString2 isEqualToString:@"LONG_TEXT"]) {
            newEventItem.descript = [[value2 objectForKey:@"description"] stringByConvertingHTMLToPlainText];
        }else if ([keyString2 isEqualToString:@"HYPERLINK"]) {
            newEventItem.siteURL = [value2 objectForKey:@"siteLink"];
            newEventItem.facebookURL = [value2 objectForKey:@"facebookUrl"];
        }else if ([keyString2 isEqualToString:@"IMAGE"]) {
        }else if ([keyString2 isEqualToString:@"TIMEDATE"]){
            newEventItem.startDate = [newEventItem convertLongNumberToDate:[value2 objectForKey:@"startDate"]];
            newEventItem.endDate = [newEventItem convertLongNumberToDate:[value2 objectForKey:@"endDate"]];
        }else if ([keyString2 isEqualToString:@"itemId"]) {
            newEventItem.ID= [dict objectForKey:@"itemId"];
        }else if ([keyString2 isEqualToString:@"REF_N1"]){
            NSDictionary *idDictionary = [dict objectForKey:@"REF_N1"];
            newEventItem.clubReferenceID = [idDictionary objectForKey:@"location"];
        }
        
    }
    return newEventItem;
}

- (UIImage *) loadImageFromURLwithName:(NSString *) imageUrl {
 
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:urlData];
    
    return image;
}

@end

