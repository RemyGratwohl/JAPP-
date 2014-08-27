//
//  Common.h
//  JAPP
//
//  Created by Remy Gratwohl on 05/08/14.
//
//

#ifndef JAPP_Common_h
#define JAPP_Common_h

#define IS_IPHONE_SERIES_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE_SERIES_4 ( [ [ UIScreen mainScreen ] bounds ].size.height == 480 )

typedef enum{
  LOCATION,EVENT,NEWS
} ItemType;

static NSString const *serverNewsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Post%22,%22TIMEDATE%22:null,%22TIMEDATE_from%22:null,%22TIMEDATE_to%22:null,%22TIMEDATE_fromNow%22:{%22expireDate%22:%22+0d%22},%22TIMEDATE_fromNow%22:{%22publishDate%22:%22-1y%22},%22TIMEDATE_selected%22:null}}&locale=de-CH&locales=de-CH";

static NSString const *serverLocationsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Location%22}}&locale=de-CH&locales=de-CH";

static NSString const  *serverEventsQueryString = @"operation=get_many&criteriaJson={%22item%22:{%22locale%22:%22de-CH%22,%22itemType%22:%22Event%22,%22itemId%22:-1,%22TIMEDATE%22:null,%22TIMEDATE_from%22:null,%22TIMEDATE_to%22:null,%22TIMEDATE_fromNow%22:{%22expireDate%22:%22+0d%22},%22TIMEDATE_fromNow%22:{%22publishDate%22:%22+1y%22},%22TIMEDATE_selected%22:null}}&itemType=Event&locale=de-CH&locales=de-CH";

static NSString *HostReachabilityURL = @"www.sitewalk.com";
static NSString *serverURL = @"http://japp.14.skintest.lan/Portals/0/contortionistUniverses/397/editSkins/persistence.ashx";
static NSString *serverTestingURL = @"japp.14.skintest.lan";

static NSString *treffLetter = @"t";
static NSString *organizationLetter = @"o";

static NSString *datenschutzText = @"Die APP sammelt und speichert keine personenbezogenen Daten. Daten, welche Sie uns zusenden, verwenden wir ausschliesslich zur Beantwortung Ihrer Anfragen, zur Verbesserung APP oder um mit Ihnen zu kommunizieren. Sämtliche automatischen Informationen, welche wir empfangen und speichern, werden ausschliesslich zu internen Zwecken ausgewertet. Auch verlangen wir von Ihnen keine persönlichen Angaben. Wir verpflichten uns dazu, Daten, welche an uns gelangen, nur dann an Dritte weiterzuleiten, wenn dies mit dem Datenschutzgesetz vereinbar ist.";


#endif
