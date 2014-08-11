//
//  NewsItem.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "BaseItem.h"

@interface NewsItem : BaseItem

@property NSString *title;
@property NSString *summary;
@property NSString *authorName;
@property NSNumber *clubReferenceID;

- (NSDate*) convertLongNumberToDate:(NSNumber *)dateLong;

@end
