//
//  AgendaListeDetailCell.h
//  JAPP
//
//  Created by Remy Gratwohl on 25/06/14.
//
//

#import <UIKit/UIKit.h>

@interface AgendaListeDetailCell : UITableViewCell

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
