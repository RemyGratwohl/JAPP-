//
//  AgendaListeCell.h
//  JAPP
//
//  Created by Remy Gratwohl on 23/06/14.
//
//

#import <UIKit/UIKit.h>

@interface AgendaListeCell : UITableViewCell

// Labels
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

// ImageViews
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
