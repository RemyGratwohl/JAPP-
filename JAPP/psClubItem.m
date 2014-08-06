//
//  psToDoItem.m
//  ToDoList
//
//  Created by Patrik on 21.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import "psClubItem.h"
#import "psCommon.h"

@interface psClubItem()


@end

@implementation psClubItem

NSString* const PrefixImageSave = @"";

@synthesize location = _location;
@synthesize itemImage = _itemImage;
@synthesize imageLocalUrl = _imageLocalUrl;


- (id)init {
    
    prefixImageSave = PrefixImageSave;
    
    return self;
    
}

//-(NSString *) getPrefixForSave {
//    return PrefixImageSave;
//}

-(BOOL) hasImageChanged {
    
    return imageChanged;
    
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.location forKey:@"loc"];
    
    if(imageChanged) {
        
        NSString *saveName = [PrefixImageSave stringByAppendingString:self.itemId];
        
        self.imageLocalUrl = [psCommon saveImageToLocalDir:self.itemImage withFileName:saveName ofType:@"PNG"];
    }

    [encoder encodeObject:self.imageLocalUrl forKey:@"imgurl"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super initWithCoder:decoder]) {
        self.location = [decoder decodeObjectForKey:@"loc"];
        self.imageLocalUrl = [decoder decodeObjectForKey:@"imgurl"];
    }
    return self;
}

-(UIImage *) loadLocalImage {
    
    if(self.itemImage == nil && self.imageLocalUrl != nil && self.imageLocalUrl.length > 0) {
        _itemImage = [psCommon getImageFromFileURL:self.imageLocalUrl];
        
    }
    
    return _itemImage;
    
}

-(void) setImage: (UIImage *) image {
    
    _itemImage = image;
    imageChanged = TRUE;
    
}


@end
