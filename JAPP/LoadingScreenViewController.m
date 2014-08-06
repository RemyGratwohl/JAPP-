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

@interface LoadingScreenViewController ()

@property (strong,nonatomic) ServerManager *manager;

// Store the retrieved Data
@property NSArray *retrievedLocations;
@property NSArray *retrievedEvents;
@property NSArray *retrievedNews;

@end


@implementation LoadingScreenViewController

#pragma mark - Default Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonFunctions setResolutionFriendlyImageNamed:@"Loading-Screen" forImageView:self.backgroundImageView];
    
    /*UIActivityIndicatorView *activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorObject.center = CGPointMake(self.view.bounds.size.width / 2,self.view.bounds.size.height-80);
    activityIndicatorObject.transform = CGAffineTransformMakeScale(4, 4);
    [self.view addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];*/
    
    self.manager = [[ServerManager alloc] init];
    self.manager.delegate = self;
    
    [self loadAllTheData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Data Retrieval


// Loads the data for all three item types in
// the order of Locations, Events, and then News
-(void) loadAllTheData{
    [self.manager doLoadDataFromServerOfType:LOCATION];
}

#pragma mark - Callbacks for Loaded Data

- (void) didFinishLoadingLocations:(NSMutableArray *)locations{
    self.retrievedLocations = [NSArray arrayWithArray:locations];
    //[self.manager doLoadDataFromServerOfType:EVENT];
    [self performSegueWithIdentifier: @"openMapViewController" sender: self];
}

- (void) didFinishLoadingEvents:(NSMutableArray *)events{
    self.retrievedLocations = [NSArray arrayWithArray:events];
    [self.manager doLoadDataFromServerOfType:NEWS];

}

- (void) didFinishLoadingNews:(NSMutableArray *)news{
    self.retrievedNews = [NSArray arrayWithArray:news];
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
