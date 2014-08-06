//
//  psToDoItem.h
//  ToDoList
//
//  Created by Patrik on 21.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface psClubItem : BaseItem <NSCoding> {
    
    NSString *prefixImageSave;
    BOOL imageChanged; // This is for efficency, so not everytime the same image gets saved again

}

@property NSString *location;
@property (readonly) UIImage *itemImage;
@property NSString *imageLocalUrl;


-(UIImage *) loadLocalImage;
-(void) setImage: (UIImage *) image;

-(BOOL) hasImageChanged;

@end
