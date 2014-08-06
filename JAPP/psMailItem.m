//
//  psToDoItem.m
//  ToDoList
//
//  Created by Patrik on 21.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import "psMailItem.h"
#import "psServerManager.h"

@implementation psMailItem

NSString* const PrefixImageMailSave = @"M";


- (id)init {
    
    prefixImageSave = PrefixImageMailSave;
   
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeBool:self.newPost forKey:@"newPost"];
    [encoder encodeObject:self.imageRemoteName forKey:@"imgRemoteUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super initWithCoder:decoder]) {
        self.newPost = [decoder decodeBoolForKey:@"newPost"];
        self.imageRemoteName = [decoder decodeObjectForKey:@"imgRemoteUrl"];
    }
    return self;
}

- (UIImage *) loadRemoteImage {
/*
    if(self.imageRemoteName != nil && self.imageRemoteName.length > 0) {
    
        psServerManager *server =[ [psServerManager alloc] init];

        // Load image with url from server
        UIImage *realImage = [server loadImageFromURLwithName: self.imageRemoteName];
        // Store it locally
        [psCommon saveImageToLocalDir:realImage withFileName:  self.imageRemoteName];
        // Put also into item
        [self setImage:realImage];

        return realImage;
        //NSLog(@"Remote image loaded: %@", newMail.itemImageRemoteName);
            
    }
    */
    return nil;

}


- (void) setDateFromNumber:(NSNumber *)dateLong {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateZero = [formatter dateFromString:@"0001-01-01"];
    
    NSDate *dateCalc =[dateZero dateByAddingTimeInterval:([dateLong doubleValue] / 10000000)];
    self.itemDate = dateCalc;
    
}



@end
