//
//  TreffseiteViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 20/06/14.
//
//

#import "TreffSeiteViewController.h"
#import "Utilities.h"
#import "NewsItem.h"
#import "UIImageView+WebCache.h"

@interface TreffSeiteViewController ()

@end

@implementation TreffSeiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [Utilities setResolutionFriendlyImageNamed:@"TreffSeiteBackgroundImage" forImageView:self.backgroundImageView];
    
    UIFont* textFont = [UIFont fontWithName:@"Lato-Regular" size:18];

    [self.nameLabel setFont:textFont];
    
    self.descriptionTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    [self.descriptionTextView setText:self.selectedLocation.descript];
    
    [self.nameLabel setText:[self.selectedLocation.name uppercaseString]];
    
    self.openingTimesLabel.text = self.selectedLocation.hoursOfOperation;
    [self.countryLabel setText:self.selectedLocation.country];
    [self.address1Label setText:self.selectedLocation.address1];
    [self.postalCodeLabel setText:self.selectedLocation.postalCode];
    [self.cityLabel setText: self.selectedLocation.place];
    
    
    
    [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:self.selectedLocation.imageURL ]];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bannerImage.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){15, 15}].CGPath;
    
    self.bannerImage.layer.mask = maskLayer;
    
    
    [self initalizeNewsUI];
    
    
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
    
    if ([self.selectedLocation.mapURL isEqualToString:@""]){
        self.showInMapsButton.enabled = false;
    }
}

-(void)initalizeNewsUI{
    NSArray *newsLabels = [NSArray arrayWithObjects:self.news1Label,self.news2Label,self.news3Label, nil];
    NSMutableArray *recentNews =[[NSMutableArray alloc] init];
    UIFont* textFont = [UIFont fontWithName:@"Lato-Regular" size:14];
    
    if([self.locationNews count] >= 1){
        [recentNews addObject: [self.locationNews objectAtIndex:0]];
    }
    if([self.locationNews count] >= 2){
        [recentNews addObject: [self.locationNews objectAtIndex:1]];
    }
    if([self.locationNews count] >= 3){
        [recentNews addObject:[self.locationNews objectAtIndex:2]];
    }
    
    for(UILabel *l in newsLabels){
        [l setFont:textFont];
        [l setText:@""];
    }
    
    if([recentNews count] == 0){
        [self.news2Label setText:@"Kein Aktuelle Nachrichten"];
    }else{
        for(int i = 0; i < [recentNews count]; i++){
            UILabel *label = [newsLabels objectAtIndex:i];
            NewsItem *news = [recentNews objectAtIndex:i];
            
            [label setText: news.title];
        }
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

- (IBAction)treffAgendaButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAgendaView" object:self.selectedLocation];
    }];
}

- (IBAction)openMapsInBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.selectedLocation.mapURL]];
}


@end
