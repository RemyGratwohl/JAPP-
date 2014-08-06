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

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *showInMapsButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;



@end
