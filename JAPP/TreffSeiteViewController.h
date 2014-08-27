//
//  TreffseiteViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 20/06/14.
//
//

#import <UIKit/UIKit.h>
#import "LocationItem.h"

@interface TreffSeiteViewController : UIViewController

@property (strong,nonatomic) LocationItem *selectedLocation;
@property (strong,nonatomic) NSArray      *locationNews;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *showInMapsButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *openAgenda;

// Text Labels
@property (weak, nonatomic) IBOutlet UILabel    *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *openingTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel    *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel    *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel    *postalCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel    *address1Label;
@property (weak, nonatomic) IBOutlet UILabel    *news1Label;
@property (weak, nonatomic) IBOutlet UILabel    *news2Label;
@property (weak, nonatomic) IBOutlet UILabel    *news3Label;

// Images
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end
