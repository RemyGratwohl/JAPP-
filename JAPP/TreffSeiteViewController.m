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

- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.selectedLocation.siteURL]];
}
- (IBAction)openPhone:(id)sender {
    //[[UIApplication sharedApplication] openURL:self.currentTreff.telephoneNumber];
}


- (IBAction)openEmail:(id)sender {
    NSString *url = [NSURL URLWithString: self.selectedLocation.email];
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
}

- (IBAction)openFacebook:(id)sender {
}


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
