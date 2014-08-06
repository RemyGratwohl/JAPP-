//
//  psDataManager.h
//  HuberApp
//
//  Created by Sitewalk on 30.01.14.
//  Copyright (c) 2014 Sitewalk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerManager;

@protocol ServerLoadFinishedDelegate <NSObject>
@required

- (void) didFinishLoadingLocations: (NSMutableArray *)locations;
- (void) didFinishLoadingEvents:    (NSMutableArray *)events;
- (void) didFinishLoadingNews:      (NSMutableArray *)news;
@end

@interface ServerManager : NSObject <NSURLConnectionDelegate> {
    
@private
    NSMutableData * responseData;
}

// Server Manger is stateless
@property (nonatomic, weak) id <ServerLoadFinishedDelegate> delegate;

-(void) doLoadDataFromServerOfType: (int) ObjectType;

@end
