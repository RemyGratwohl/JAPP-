//
//  TreffseiteViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 20/06/14.
//
//

#import "TreffSeiteViewController.h"
#import "CommonFunctions.h"

@interface TreffSeiteViewController ()

@end

@implementation TreffSeiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CommonFunctions setResolutionFriendlyImageNamed:@"Treffseite" forImageView:self.backgroundImageView];
    [self setSwipeGestureDirection:UISwipeGestureRecognizerDirectionDown numberOfTocuhesRequired:1];
    
    NSLog(@"%@",self.selectedLocation);
    [self.nameLabel setText:self.selectedLocation.name];
    [self.cityLabel setText:self.selectedLocation.place];
    self.openingTimesLabel.text = self.selectedLocation.hoursOfOperation;
    [self.countryLabel setText:self.selectedLocation.country];
    [self.address1Label setText:self.selectedLocation.address1];
    [self.postalCodeLabel setText:self.selectedLocation.postalCode];
    
    [self.bannerImage setImage:self.selectedLocation.bannerImage];
    
    if([self.selectedLocation.siteURL  isEqual: @""]){
        self.websiteButton.enabled = false;
    }
    if ([self.selectedLocation.facebookURL isEqualToString:@""]){
        self.facebookButton.enabled = false;
    }
    if ([self.selectedLocation.phoneNumber isEqualToString:@""]){
        self.phoneButton.enabled = false;
    }
    if ([self.selectedLocation.email isEqualToString:@""]){
        self.emailButton.enabled = false;
    }
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarnsing
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Event Listeners
- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.selectedLocation.siteURL]];
}

- (IBAction)openPhone:(id)sender {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"tel:%@",self.selectedLocation.phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openEmail:(id)sender {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"mailto:%@",self.selectedLocation.email]];
    [[UIApplication sharedApplication]  openURL: url];
}

- (IBAction)openFacebook:(id)sender {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"fb:%@",self.selectedLocation.facebookURL]];
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:url];
    if(isInstalled){
        [[UIApplication sharedApplication]  openURL: url];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.selectedLocation.facebookURL]];
    }
}

- (IBAction)openMapsInBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.selectedLocation.mapURL]];
}

#pragma mark Gesture Recogonizer

-(void)setSwipeGestureDirection:(UISwipeGestureRecognizerDirection)direction numberOfTocuhesRequired:(int)num{
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    
    swipeGesture.numberOfTouchesRequired = num;
    swipeGesture.direction= direction;
    
    [self.view addGestureRecognizer:swipeGesture];
}

/*
#pragma mark - Navigations

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
