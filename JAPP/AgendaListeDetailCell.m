//
//  AgendaListeDetailCell.m
//  JAPP
//
//  Created by Remy Gratwohl on 25/06/14.
//
//

#import "AgendaListeDetailCell.h"

@implementation AgendaListeDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for (id obj in self.subviews) {
            if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
                [obj setDelaysContentTouches:NO];
            }
        }

    }
    
    return self;
    
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openFacebookPage:(id)sender {

}

- (IBAction)openWebsite:(id)sender {
}

- (IBAction)openPhone:(id)sender {
}

@end
