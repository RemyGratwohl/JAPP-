//
//  NewsItem.m
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "NewsItem.h"

@implementation NewsItem

- (NSString *)description {
    return [NSString stringWithFormat: @"\nTitle=%@\nID=%@\nSiteURL=%@\nAuthorName=%@\n", self.title,self.ID,self.siteURL,self.authorName];
}

/*
-(void)encodeWithCoder:(NSCoder *)encoder{
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.authorName forKey:@"authorName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super initWithCoder:decoder]) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.authorName = [decoder decodeObjectForKey:@"authorName"];
    }
    return self;
}
*/

- (NSDate*) convertLongNumberToDate:(NSNumber *)dateLong {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *dateZero = [formatter dateFromString:@"0001-01-01-01-06"];
    
    NSDate *dateCalc =[dateZero dateByAddingTimeInterval:([dateLong doubleValue] / 10000000)];
    
    return dateCalc;
}

@end
