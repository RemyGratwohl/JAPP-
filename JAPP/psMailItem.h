//
//  psToDoItem.h
//  ToDoList
//
//  Created by Patrik on 21.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "psClubItem.h"

@interface psMailItem : psClubItem 

@property BOOL newPost;
@property NSString *imageRemoteName;

- (void) assignShortLongTextFromDict:(NSDictionary *)items withlanguageId:(NSString *)langId;

- (void) setDateFromNumber:(NSNumber *)dateLong;

- (UIImage *) loadRemoteImage;

@end
