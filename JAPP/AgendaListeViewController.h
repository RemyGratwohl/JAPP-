//
//  AgendaListeViewController.h
//  JAPP
//
//  Created by Remy Gratwohl on 23/06/14.
//
//

#import <UIKit/UIKit.h>

@interface AgendaListeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Constants
extern const float FILTER_TABLEVIEW_ROW_HEIGHT;
extern const float AGENDA_TABLEVIEW_NORMAL_ROW_HEIGHT;
extern const float AGENDA_TABLEVIEW_DETAIL_ROW_HEIGHT;


// TableViews
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *filterButtonTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

// Data
@property (strong,nonatomic) NSArray *locations;
@property (strong,nonatomic) NSArray *events;




@end
