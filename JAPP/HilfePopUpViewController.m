//
//  HilfePopUpViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 17/06/14.
//
//

#import "HilfePopUpViewController.h"
#import "Utilities.h"

@interface HilfePopUpViewController ()

@end

@implementation HilfePopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [Utilities setResolutionFriendlyImageNamed:@"HilfePopupBackground" forImageView:self.backgroundImageView];
    
    // Initalize Text-Based UI
    UIFont* textFont = [UIFont fontWithName:@"Lato-Regular" size:13];
    
    [self.datenschutzTextView setFont:textFont];
    [self.datenschutzTextView setTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f]];
    [self.datenschutzTextView setText: datenschutzText];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    [self.impressumLabel setFont:textFont];
     self.impressumLabel.text = [NSString stringWithFormat:@"© %@ \nVerein Liechtensteiner \nJugendorganisationen",yearString];
    
    // Close View on Downwards Swipe
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)treffListeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openTreffListeView" object:nil];
    }];
}

- (IBAction)agendaButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAgendaView" object:nil];
    }];
}

- (IBAction)sitewalkLogoPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.sitewalk.com"]];
}

- (IBAction)arminLogoPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.armindesign.li"]];
}

@end
