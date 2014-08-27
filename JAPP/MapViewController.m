//
//  ViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 11/06/14.
//
//

#import "MapViewController.h"
#import "Common.h"
#import "Utilities.h"
#import "LocationItem.h"
#import "Reachability.h"
#import "TreffListeViewController.h"
#import "TreffSeiteViewController.h"
#import "AgendaListeViewController.h"
#import "NewsItem.h"

@interface MapViewController ()
    @property (strong,nonatomic)  ServerManager  *manager;
    @property (strong, nonatomic) Reachability   *hostReachability;
    @property (strong,nonatomic)  NSMutableArray *mapButtonArray;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapButtonArray = [[NSMutableArray alloc] init];
    self.manager = [[ServerManager alloc] init];
    self.manager.delegate = self;
    self.hostReachability = [Reachability reachabilityWithHostName: HostReachabilityURL];
    
    [Utilities setResolutionFriendlyImageNamed:@"MapViewBackgroundImage" forImageView:self.backgroundImageView];
    
    [self generateMapIcons];

    // Segue Notifcations
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(performSegueUsingNotification:)
                                                 name: @"openHilfePopUpView"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(performSegueUsingNotification:)
                                                 name: @"openTreffDetailView"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(performSegueUsingNotification:)
                                                 name: @"openTreffListeView"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(performSegueUsingNotification:)
                                                 name: @"openAgendaView"
                                               object: nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(networkChanged:)
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];
}

// Performs Segue Using a Notification's Name
-(void)performSegueUsingNotification:(NSNotification*)notification{
    
    if([[notification  name]  isEqual: @"openTreffDetailView"]){
        
        LocationItem *sentLocation = [notification object];
        
        [self performSegueWithIdentifier:[notification name
                                          ] sender:sentLocation.ID];
        
    }else{
    
        [self performSegueWithIdentifier:[notification name
                                      ] sender:self];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

-(BOOL)generateMapIcons{
    
    [self clearButtons];
    
    for(LocationItem *key in self.locations){

        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // The positions need to be divided by two because of the retina display
        // 26 x 26 is the icon size provided
        /* For the iphone 4, it was necessary to resize the background image map in photoshop, so
           80% scale down and 25 shift left was done */
        
        if(IS_IPHONE_SERIES_5){
            newButton.frame = CGRectMake( key.posX / 2, key.posY / 2, 26, 26);
        }else if (IS_IPHONE_SERIES_4){
            newButton.frame = CGRectMake( key.posX / 2 * 0.8 + 25, key.posY * 0.8 / 2, 26, 26);
        }else{
            NSLog(@"Unable to place map icons due to unknown screen size");
            return NO;
        }
        
        newButton.tag = [key.ID integerValue];
        
        if([key.type isEqualToString:treffLetter]){
            [newButton setBackgroundImage:[UIImage imageNamed:@"TreffIconImage"] forState: UIControlStateNormal];
        }else if ([key.type isEqualToString:organizationLetter]){
            [newButton setBackgroundImage:[UIImage imageNamed:@"OrganisationIconImage"] forState: UIControlStateNormal];
        }else{
            NSLog(@"Unknown Club Type!");
        }
        
        [newButton addTarget:self
                      action:@selector(mapIconPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [self.mapButtonArray addObject:newButton];
        [self.view addSubview:newButton];
    }
    
    return YES;
}

-(void)clearButtons{
    for(UIButton *b in self.mapButtonArray){
        [b removeFromSuperview];
    }
}

-(void)mapIconPressed: (UIButton*) button{
    NSNumber *idOfBUtton = [NSNumber numberWithInteger:button.tag ];
    [self performSegueWithIdentifier: @"openTreffDetailView" sender: idOfBUtton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)networkChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus = [self.hostReachability currentReachabilityStatus];
    
    // Get data if either Wifi or GSM/Edge/... connected
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"No connection to sitewalk.com host possible");
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        [self.manager doLoadDataFromServerOfType:EVENT];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        [self.manager doLoadDataFromServerOfType:EVENT];
    }
    
}

-(void)didFinishLoadingItems:(NSMutableArray *)items ofType:(ItemType)type{
    
    switch(type){
        case(LOCATION):
            // Location updating adds addtional traffic because they don't change often
            break;
        case(EVENT):
            self.events= [NSArray arrayWithArray:items];
            [self.manager doLoadDataFromServerOfType:NEWS];
            break;
        case(NEWS):
            self.news= [NSArray arrayWithArray:items];
            break;
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{;
    if([[segue identifier] isEqualToString:@"openTreffListeView"]){
        TreffListeViewController *mvc = [segue destinationViewController];
        mvc.locationList = self.locations;
    }else if ([[segue identifier] isEqualToString:@"openTreffDetailView"]){
        TreffSeiteViewController *mvc = [segue destinationViewController];
        
        NSNumber *num = sender; // Abuse of sender so that both clicking on a button and the trefflistetable sends an nsnumber
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID==%d",[num integerValue]];
        mvc.selectedLocation   = [self.locations filteredArrayUsingPredicate:predicate][0];
        
        NSPredicate *newsPredicate = [NSPredicate predicateWithFormat:@"clubReferenceID=%@",mvc.selectedLocation.ID];
        
        NSArray *sortedNews= [[self.news filteredArrayUsingPredicate:newsPredicate] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first  = [(NewsItem*)a publishDate];
            NSDate *second = [(NewsItem*)b publishDate];
            return [second compare:first];
        }];
        
        mvc.locationNews = sortedNews;
        
    }else if ([[segue identifier] isEqualToString:@"openAgendaView"]){
        AgendaListeViewController *mvc = [segue destinationViewController];
        mvc.locations = self.locations;
        mvc.events = [NSMutableArray arrayWithArray:self.events];
    }
}

@end
