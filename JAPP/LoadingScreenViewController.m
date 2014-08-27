//
//  LoadingScreenViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 04/08/14.
//
//

#import "LoadingScreenViewController.h"
#import "Common.h"
#import "Utilities.h"
#import "MapViewController.h"
#import "Reachability.h"

@interface LoadingScreenViewController ()

@property (strong, nonatomic) Reachability *hostReachability;
@property (strong,nonatomic) ServerManager *manager;

// Store retrieved data
@property NSArray *retrievedLocations;
@property NSArray *retrievedEvents;
@property NSArray *retrievedNews;

@end

@implementation LoadingScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [[ServerManager alloc] init];
    self.manager.delegate = self;
    self.hostReachability = [Reachability reachabilityWithHostName: HostReachabilityURL];
    
    [Utilities setResolutionFriendlyImageNamed:@"LS-Default" forImageView:self.backgroundImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptToRetrieveData) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptToRetrieveData) name:kReachabilityChangedNotification object:nil];

    [self attemptToRetrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Animations

-(void)beginLoadingScreenAnimations{
    
    if(IS_IPHONE_SERIES_5){
        self.backgroundImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"LS1-568"],
                                                   [UIImage imageNamed:@"LS2-568"],
                                                   [UIImage imageNamed:@"LS3-568"],
                                                   [UIImage imageNamed:@"LS4-568"], nil];
    } else if (IS_IPHONE_SERIES_4){
        self.backgroundImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"LS1"],
                                                   [UIImage imageNamed:@"LS2"],
                                                   [UIImage imageNamed:@"LS3"],
                                                   [UIImage imageNamed:@"LS4"], nil];
    }
    
    [self.backgroundImageView setAnimationRepeatCount:INFINITY];
    [self.backgroundImageView setAnimationDuration:4];
    [self.backgroundImageView startAnimating];
}

# pragma mark - Data Retrieval

-(void)attemptToRetrieveData{
    
    [self beginLoadingScreenAnimations];
    
    NetworkStatus remoteHostStatus = [self.hostReachability currentReachabilityStatus];
    
    // Retrieve the data if either Wifi or GSM/Edge/... is connected, otherwise try to load from cache
    if (remoteHostStatus == ReachableViaWiFi)
    {
        [self beginRetrievingDataFromServer];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        [self beginRetrievingDataFromServer];
    }else{
        NSLog(@"No connection to sitewalk.com host possible, attempting to retrieve cached data");
        self.retrievedLocations = [self retrieveDataFromCacheOfType:@"Location"];
        self.retrievedEvents = [self retrieveDataFromCacheOfType:@"Event"];
        self.retrievedNews = [self retrieveDataFromCacheOfType:@"Post"];
        
        if(self.retrievedNews && self.retrievedLocations && self.retrievedEvents){
            [self performSegueWithIdentifier: @"openMapViewController" sender: self];
        }else{
            [self.backgroundImageView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Turn Off Airplane Mode or Use Wi-Fi to Access Initial Data"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            
            [alert show];
        }
    }
}


// Loads the data for all three item types in
// the order of Locations, Events, and then News
-(void) beginRetrievingDataFromServer{
    [self.manager doLoadDataFromServerOfType:LOCATION];
    [self.manager doLoadDataFromServerOfType:EVENT];
    [self.manager doLoadDataFromServerOfType:NEWS];
}

-(NSArray*) retrieveDataFromCacheOfType:(NSString*)type{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:type];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSData *cachedData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedDataDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:cachedData];
    
        return [NSArray arrayWithArray:[self.manager decodeJSONItems:savedDataDictionary]];
        
    }else{
        NSLog(@"Unable to find cache for data of type: %@",type);
        return nil;
    }
}

#pragma mark - Callbacks for Loaded Data

-(void)didFinishLoadingItems:(NSMutableArray *)items ofType:(ItemType)type{

    switch(type){
        case(LOCATION):
            self.retrievedLocations = [NSArray arrayWithArray:items];
            break;
        case(EVENT):
            self.retrievedEvents = [NSArray arrayWithArray:items];
            break;
        case(NEWS):
             self.retrievedNews = [NSArray arrayWithArray:items];
            break;
    }
    
    if(self.retrievedEvents && self.retrievedLocations && self.retrievedNews){
        [self.backgroundImageView stopAnimating];
        [Utilities setResolutionFriendlyImageNamed:@"LS-Finished" forImageView:self.backgroundImageView];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self performSelector:@selector(segueToMapViewController) withObject:nil afterDelay:1.5];
    }

}

-(void)segueToMapViewController{
    [self performSegueWithIdentifier: @"openMapViewController" sender: self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MapViewController *mvc = [segue destinationViewController];
    
    mvc.locations = self.retrievedLocations;
    mvc.events = self.retrievedEvents;
    mvc.news = self.retrievedNews;
}

@end
