//
//  LoadingScreenViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 04/08/14.
//
//

#import "MapViewController.h"
#import "ServerManager.h"

@interface LoadingScreenViewController : UIViewController <ServerLoadFinishedDelegate, UIAlertViewDelegate,UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
