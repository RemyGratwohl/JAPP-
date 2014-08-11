//
//  LoadingScreenViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 04/08/14.
//
//

#import "LoadingScreenViewController.h"
#import "Common.h"
#import "CommonFunctions.h"
#import "MapViewController.h"
#import "Reachability.h"

@interface LoadingScreenViewController ()

@property (strong, nonatomic) Reachability *hostReachability;
@property (strong,nonatomic) ServerManager *manager;

// Stores the retrieved data temporarily
@property NSArray *retrievedLocations;
@property NSArray *retrievedEvents;
@property NSArray *retrievedNews;

@end


@implementation LoadingScreenViewController

#pragma mark - Default Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.manager = [[ServerManager alloc] init];
    self.manager.delegate = self;
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.sitewalk.com" ]; // @"www.google.ch"
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptToRetrieveData) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptToRetrieveData) name:kReachabilityChangedNotification object:nil];
    
    [CommonFunctions setResolutionFriendlyImageNamed:@"Loading-Screen" forImageView:self.backgroundImageView];
    [self attemptToRetrieveData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // TODO: User Presss OK on AlertView
    }
}

# pragma mark - Animations

-(void)beginLoadingScreenAnimations{
    if([UIScreen mainScreen].bounds.size.height == 568){
        self.backgroundImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"LS1-568"],
                                                    [UIImage imageNamed:@"LS2-568"],
                                                    [UIImage imageNamed:@"LS3-568"],
                                                    [UIImage imageNamed:@"LS4-568"], nil];
    }else{
        self.backgroundImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"LS1"],
                                                    [UIImage imageNamed:@"LS2"],
                                                    [UIImage imageNamed:@"LS3"],
                                                    [UIImage imageNamed:@"LS4"], nil];
    }
    
    [self.backgroundImageView setAnimationRepeatCount:INFINITY];
    [self.backgroundImageView setAnimationDuration:4];
    [self.backgroundImageView startAnimating];
}


# pragma mark - Data Retrieval

// Loads the data for all three item types in
// the order of Locations, Events, and then News
-(void) beginRetrievingDataFromServer{
    [self.manager doLoadDataFromServerOfType:LOCATION];
}

-(NSArray*) retrieveDataFromCacheOfType:(NSString*)type{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:type];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *cachedData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedDataDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:cachedData];
        
        ServerManager *newManager = [[ServerManager alloc] init];
        
        return [NSArray arrayWithArray:[newManager decodeJSONItems:savedDataDictionary]];
        
    }else{
        NSLog(@"Unable to find cache for data of type: %@",type);
        return nil;
    }
}

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
        
        if(self.retrievedNews != nil && self.retrievedLocations != nil && self.retrievedEvents != nil){
            [self performSegueWithIdentifier: @"openMapViewController" sender: self];
        }else{
            [self.backgroundImageView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Unable to Connect to the Server"
                                  message:@"Please connect to the internet and retry"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }
}

#pragma mark - Callbacks for Loaded Data

-(void)didFinishLoadingItems:(NSMutableArray *)items ofType:(ItemType)type{

    switch(type){
        case(LOCATION):
            self.retrievedLocations = [NSArray arrayWithArray:items];
            [self.manager doLoadDataFromServerOfType:EVENT];
            
            break;
        case(EVENT):
            self.retrievedEvents = [NSArray arrayWithArray:items];
            [self.manager doLoadDataFromServerOfType:NEWS];
            break;
        case(NEWS):
             self.retrievedNews = [NSArray arrayWithArray:items];
            [self performSegueWithIdentifier: @"openMapViewController" sender: self];
            break;
    }
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
