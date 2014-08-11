//
//  psDataManager.h
//  HuberApp
//
//  Created by Sitewalk on 30.01.14.
//  Copyright (c) 2014 Sitewalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class ServerManager;

@protocol ServerLoadFinishedDelegate <NSObject>
@required

-(void) didFinishLoadingItems: (NSMutableArray *)items ofType: (ItemType)type;

@end

@interface ServerManager : NSObject <NSURLConnectionDelegate> {
    
@private
    NSMutableData * responseData;
}

- (NSMutableArray *) decodeJSONItems:(NSDictionary *) resJson;

// Server Manger is stateless
@property (nonatomic, weak) id <ServerLoadFinishedDelegate> delegate;

-(void) doLoadDataFromServerOfType: (int) ObjectType;

@end
