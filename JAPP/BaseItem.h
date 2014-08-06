//
//  psBaseItem.h
//  
//
//  Created by Patrik on 24.01.14.
//
//

#import <Foundation/Foundation.h>

@class BaseItem;

@interface BaseItem : NSObject <NSCoding>

@property NSString *ID;
@property NSString *name;
@property NSString *description;

@end
