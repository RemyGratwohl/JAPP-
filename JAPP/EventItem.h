//
//  EventItem.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#import "NewsItem.h"

@interface EventItem : NewsItem

@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSDate *endDate;

@end
