//
//  ViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 11/06/14.
//
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "Reachability.h"

@interface MapViewController : UIViewController <ServerLoadFinishedDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) Reachability *hostReachability;

@property (strong,nonatomic) NSArray *locations;
@property (strong,nonatomic) NSArray *events;
@property (strong,nonatomic) NSArray *news;

@property (strong,nonatomic) NSMutableArray *buttons;

@end
