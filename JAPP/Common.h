//
//  Common.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#ifndef JAPP_Common_h
#define JAPP_Common_h

typedef enum{
  LOCATION,EVENT,NEWS
} ItemType;

static NSString *serverNewsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Post%22,%22TIMEDATE%22:null,%22TIMEDATE_from%22:null,%22TIMEDATE_to%22:null,%22TIMEDATE_fromNow%22:{%22expireDate%22:%22+0d%22},%22TIMEDATE_fromNow%22:{%22publishDate%22:%22-1y%22},%22TIMEDATE_selected%22:null}}&locale=de-CH&locales=de-CH";

static NSString *serverLocationsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Location%22}}&locale=de-CH&locales=de-CH";

static NSString *serverEventsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Event%22,%22itemId%22:-1,%22TIMEDATE%22:null,%22TIMEDATE_from%22:null,%22TIMEDATE_to%22:null,%22TIMEDATE_fromNow%22:{%22expireDate%22:%22+0d%22},%22TIMEDATE_fromNow%22:{%22publishDate%22:%22+1y%22},%22TIMEDATE_selected%22:null}}&itemType=Event&locale=de-CH&locales=de-CH";

static NSString *serverURL = @"http://japp.14.skintest.lan/Portals/0/contortionistUniverses/397/editSkins/persistence.ashx";
static NSString *imageURL = @"http://japp.14.skintest.lan/Portals/0/contortionistUniverses/397/img/";

#endif
