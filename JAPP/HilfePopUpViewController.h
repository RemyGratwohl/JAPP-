//
//  HilfePopUpViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 17/06/14.
//
//  View Controller for displaying the map legend, information privacy, and links to the developer/designer websites.

#import <UIKit/UIKit.h>

@interface HilfePopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView  *datenschutzTextView;
@property (weak, nonatomic) IBOutlet UILabel     *impressumLabel;

@property (weak, nonatomic) IBOutlet UIButton *arminLogoButton;
@property (weak, nonatomic) IBOutlet UIButton *sitewalkLogoButton;


@end
