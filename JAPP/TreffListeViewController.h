//
//  TreffListeViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 13/06/14.
//
//

#import <UIKit/UIKit.h>

@interface TreffListeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// TableViews
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong,nonatomic) NSArray *locationList;

@end
