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

@interface ServerManager()


@end

@implementation ServerManager


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
    
    if(connection == nil) {
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
    
    NSString* resString =  [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",resString);
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    //convert to JSON
    NSError *myError = nil;
    NSDictionary *resJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSMutableArray *items = [self decodeJSONItems:resJson];
    [self.delegate didFinishLoadingLocations:items];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"Connection to server failed: %@; %@", error.localizedDescription, error.localizedFailureReason);
}

- (NSMutableArray *) decodeJSONItems:(NSDictionary *) resJson {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //Search all values
    for(id key in resJson) {
        
        id value = [resJson objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        
        if ([keyAsString isEqualToString:@"isSuccess"]) {
            // Ignore
        } else if ([keyAsString isEqualToString:@"message"]) {
            // Ignore
            
        } else if ([keyAsString isEqualToString:@"items"]) {
            
            NSArray *tempItems = (NSArray *)value;
            
            for (id keyValuePair in tempItems) { // id detailItem
                
                
                NSDictionary *detailsDict  = (NSDictionary *) keyValuePair;
                
                LocationItem *lItem = [[LocationItem alloc] init];
                [items addObject:lItem];
 
                for(id key2 in detailsDict) {
                    
                    NSString *keyString2 = (NSString *)key2;
                    id value2 = [detailsDict objectForKey:keyString2];
                    
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
                    }else if ([keyString2 isEqualToString:@"LONG_TEXT"]) {
                        lItem.description = [[value2 objectForKey:@"description"] stringByConvertingHTMLToPlainText];
                    }else if ([keyString2 isEqualToString:@"HYPERLINK"]) {
                        lItem.siteURL = [value2 objectForKey:@"siteUrl"];
                        lItem.facebookURL = [value2 objectForKey:@"facebookUrl"];
                        
                    }else if ([keyString2 isEqualToString:@"IMAGE"]) {
                        
                    }else if ([keyString2 isEqualToString:@"INT"]){
                        
                        lItem.posX = [[value2 objectForKey:@"posX"] integerValue];
                        lItem.posY = [[value2 objectForKey:@"posY"] integerValue];
                    /*
                    } else if ([keyString2 isEqualToString:@"IMAGE"]) {
                        NSDictionary *imageDateDict  = (NSDictionary *) value2;
                        NSString *imageName = (NSString *) [imageDateDict objectForKey:@"image"];
                        mailItem.imageRemoteName = imageName;
                     */
                        
                    } else if ([keyString2 isEqualToString:@"itemId"]) {
                        lItem.ID= [detailsDict objectForKey:@"itemId"];
                        
                    }
                    
                }
             
            }
            
        }
    }
    
    /* LOG ITEMS
    for(id obj in items){
        NSLog(@"%@",[obj description]);
    }
    */
    return items;
}


- (UIImage *) loadImageFromURLwithName:(NSString *) imageName {
 
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", serverURL, imageName];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:urlData];
    
    return image;
}


@end

