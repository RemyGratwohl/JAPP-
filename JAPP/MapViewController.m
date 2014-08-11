//
//  ViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 11/06/14.
//
//

#import "MapViewController.h"
#import "Common.h"
#import "CommonFunctions.h"
#import "UIImage+ImageEffects.h"
#import "LocationItem.h"
#import "TreffListeViewController.h"
#import "TreffSeiteViewController.h"
#import "AgendaListeViewController.h"

@interface MapViewController ()

@property (strong,nonatomic) ServerManager *manager;

@end

@implementation MapViewController

UIButton *ButtonPressed;
LocationItem *sentLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttons = [[NSMutableArray alloc] init];
    self.manager.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    [CommonFunctions setResolutionFriendlyImageNamed:@"JAPP_BG" forImageView:self.backgroundImageView];
    
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
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:UIApplicationWillEnterForegroundNotification object:nil];
     self.hostReachability = [Reachability reachabilityWithHostName:@"www.sitewalk.com" ]; // @"www.google.ch"
}

// Performs Segue Using a Notification's Name
-(void)performSegueUsingNotification:(NSNotification*)notification{
    if([[notification  name]  isEqual: @"openTreffDetailView"]){
        sentLocation = [notification object];
    }
    
    [self performSegueWithIdentifier:[notification name
                                      ] sender:self];
}


- (BOOL)shouldAutorotate {
    return NO;
}

-(BOOL)generateMapIcons{
    
    [self clearButtons];
    
    for(LocationItem *key in self.locations){

        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if([UIScreen mainScreen].bounds.size.height == 568){
            newButton.frame = CGRectMake( key.posX / 2, key.posY / 2, 26, 26);
        }else{
            newButton.frame = CGRectMake( key.posX / 2 * 0.8 + 25, key.posY * 0.8 / 2, 26, 26);
        }
        
        newButton.tag = [key.ID integerValue];
        
        
        if([key.type isEqualToString:@"t"]){
            [newButton setBackgroundImage:[UIImage imageNamed:@"treff_Icon"] forState: UIControlStateNormal];
        }else{
            [newButton setBackgroundImage:[UIImage imageNamed:@"org_icon-568"] forState: UIControlStateNormal];
        }
        
        [newButton addTarget:self
                      action:@selector(mapIconPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:newButton];
        [self.view addSubview:newButton];
    }
    
    return YES;
}

-(void)clearButtons{
    for(UIButton *b in self.buttons){
        [b removeFromSuperview];
    }
}


-(void)mapIconPressed: (UIButton*) button{
    ButtonPressed = button;
    [self performSegueWithIdentifier: @"openTreffDetailView" sender: self];
}

-(LocationItem*) findLocationByID: (NSInteger) integer{
    for(LocationItem* item in self.locations){
        if([item.ID integerValue] == integer){
            return item;
        }
    }
    
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if(ButtonPressed == NULL){
            mvc.selectedLocation = sentLocation;
        }else{
            mvc.selectedLocation = [self findLocationByID: ButtonPressed.tag];
            
        }
        
    }else if ([[segue identifier] isEqualToString:@"openAgendaView"]){
        AgendaListeViewController *mvc = [segue destinationViewController];
        mvc.locations = self.locations;
        mvc.events = [NSMutableArray arrayWithArray:self.events];
    }
}

- (void)networkChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus = [self.hostReachability currentReachabilityStatus];
    
    // Get mails if either Wifi or GSM/Edge/... connected
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"No connection to sitewalk.com host possible");
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        [self.manager doLoadDataFromServerOfType:LOCATION];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        [self.manager doLoadDataFromServerOfType:LOCATION];
    }
    
}

-(void)didFinishLoadingItems:(NSMutableArray *)items ofType:(ItemType)type{
    
    switch(type){
        case(LOCATION):
            self.locations = [NSArray arrayWithArray:items];
            [self.manager doLoadDataFromServerOfType:EVENT];
            [self generateMapIcons];
            break;
        case(EVENT):
            self.events= [NSArray arrayWithArray:items];
            [self.manager doLoadDataFromServerOfType:NEWS];
            break;
        case(NEWS):
            self.events= [NSArray arrayWithArray:items];
            break;
    }
}

@end
