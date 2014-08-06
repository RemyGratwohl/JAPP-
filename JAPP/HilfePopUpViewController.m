//
//  HilfePopUpViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 17/06/14.
//
//

#import "HilfePopUpViewController.h"

@interface HilfePopUpViewController ()

@end

@implementation HilfePopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackgroundImageNamed:@"hilfe-popup"];
    [self setSwipeGestureDirection:UISwipeGestureRecognizerDirectionDown numberOfTocuhesRequired:1];

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

-(void)setBackgroundImageNamed:(NSString*)imageName{
    if([UIScreen mainScreen].bounds.size.height == 568){
        self.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-568",imageName]];
    }else{
        self.background.image = [UIImage imageNamed:imageName];
    }
}

-(void)setSwipeGestureDirection:(UISwipeGestureRecognizerDirection)direction numberOfTocuhesRequired:(int)num{
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    
    swipeGesture.numberOfTouchesRequired = num;
    swipeGesture.direction= direction;
    
    [self.view addGestureRecognizer:swipeGesture];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
