//
//  AgendaListeViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 23/06/14.
//
//

#import "AgendaListeViewController.h"
#import "AgendaListeCell.h"
#import "AgendaListeDetailCell.h"
#import "FilterListeCell.h"
#import "EventItem.h"
#import "LocationItem.h"
#import "Utilities.h"

@interface AgendaListeViewController ()

//@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property(strong,nonatomic) NSMutableArray   *currentEventList;      // The DataSource for the main tableview
@property(strong,nonatomic) NSMutableArray   *currentFilterList;     // The DataSource for the filter tableview
@property(strong,nonatomic) LocationItem     *currentLocationFilter; // Null if filter is set to "ALL"

@end

@implementation AgendaListeViewController

// CONSTANTS
const float FILTER_TABLEVIEW_ROW_HEIGHT        =  33.0;
const float AGENDA_TABLEVIEW_NORMAL_ROW_HEIGHT =  62.0;
const float AGENDA_TABLEVIEW_DETAIL_ROW_HEIGHT = 134.0;

bool isFilterViewOpen = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    self.headerTitle.font = [UIFont fontWithName:@"Lato-Hairline" size:55];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(2,0,0,0)];
    
    // Register Nibs for TableViewCells
    [self.tableView       registerNib: [UINib nibWithNibName:@"AgendaListeDetailCell" bundle:nil] forCellReuseIdentifier:@"AgendaListeDetailCell"];
    [self.tableView       registerNib: [UINib nibWithNibName:@"AgendaListeCell" bundle:nil]       forCellReuseIdentifier:@"AgendaListeCell"];
    [self.filterTableView registerNib: [UINib nibWithNibName:@"FilterListeCell" bundle:nil]       forCellReuseIdentifier:@"FilterListeCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray *sortedEvents = [self.events sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first  = [(EventItem*)a startDate];
        NSDate *second = [(EventItem*)b startDate];
        return [first compare:second];
    }];
    
    NSArray *sortedFilter = [self.locations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first  = [(LocationItem*)a name];
        NSString*second = [(LocationItem*)b name];
        return [first caseInsensitiveCompare:second];
    }];
    
    self.currentFilterList = [sortedFilter mutableCopy];
    self.currentEventList = [sortedEvents mutableCopy];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    //Animate the filterTableView to create a dropdown effect
    //Disable button so multiple animations can not occur
    [self.filterButton setEnabled: false];
    
    [UIView animateWithDuration:0.5
                              delay:0.00
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{

                             if (!isFilterViewOpen){
                                
                                 self.filterTableView.hidden = false;
                                 [self.filterButton setImage:[UIImage imageNamed:@"DropDownFilterButtonActive-568"] forState:UIControlStateNormal];
                                 
                                 int newHeight = [self.currentFilterList count] <= 6 ? [self.currentFilterList count] * FILTER_TABLEVIEW_ROW_HEIGHT : 6 * FILTER_TABLEVIEW_ROW_HEIGHT ;
                                 [self changeHeightOf : self.filterTableView to: newHeight];
                                 
                                 int newTableViewHeight = self.tableView.frame.origin.y - 1 + newHeight;
                                 [self changeYOriginOf: self.tableView       to: newTableViewHeight];
                                 
                             }else{
                                 //Hide the FilterTableView
                                 [self changeHeightOf : self.filterTableView to: 0];
                                 [self changeYOriginOf: self.tableView       to: 133];
                             }
                         }
                         completion:^(BOOL finished){
                             
                             
                             if (finished && !isFilterViewOpen) {
                                 
                                 //Once Opening is Finished
                                 [self openFilterView];
                                 
                                 //Make sure animation did occur (Constraints need to be updated the first time)
                                 int newHeight = [self.currentFilterList count] <= 6 ? [self.currentFilterList count] * FILTER_TABLEVIEW_ROW_HEIGHT : 6 * FILTER_TABLEVIEW_ROW_HEIGHT ;
                                 [self changeHeightOf : self.filterTableView to: newHeight];
                                 
                                 int newTableViewHeight = self.filterTableView.frame.origin.y - 1 + newHeight;
                                 [self changeYOriginOf: self.tableView       to: newTableViewHeight];
                                 
                             }else if (finished && isFilterViewOpen){
                                 [self closeFilterView];
                                 [self.filterTableView reloadData];
                                 
                                 self.filterTableView.hidden = true;
                                 [self.filterButton setImage:[UIImage imageNamed:@"DropDownFilterButton-568"] forState:UIControlStateNormal];
                             }else{
                                 NSLog(@"FilterTableView Animation Unable to Finish");
                             }
                             
                             self.filterButton.enabled = true;
                         }];
}

-(void)changeHeightOf:(UIView*) UIElement to:(float)size{
    
    CGRect newElementFrame = UIElement.frame;
    newElementFrame.size.height = size;
    UIElement.frame = newElementFrame;
}

-(void)changeYOriginOf:(UIView*) UIElement to:(float)origin{
    
    CGRect newElementFrame = UIElement.frame;
    newElementFrame.origin.y  = origin;
    UIElement.frame = newElementFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (tableView == self.tableView) ? [self.currentEventList count] : [self.currentFilterList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableView){
        // Dummy String in Array acting as a placeholder for the detailcell
        if([[self.currentEventList objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
            
            AgendaListeDetailCell *newCell  = [tableView dequeueReusableCellWithIdentifier:@"AgendaListeDetailCell"];
            EventItem *newEvent = [self.currentEventList  objectAtIndex:[indexPath row] - 1]; // Get the event object of the cell above

            newCell.descriptionLabel.text = newEvent.descript;
            
            if(!newEvent.facebookURL){
                newCell.facebookButton.enabled = false;
            }else{
                newCell.facebookButton.tag = [newEvent.ID integerValue];
            }
            
            if(!newEvent.siteURL){
                newCell.websiteButton.enabled = false;
            }else{
                newCell.websiteButton.tag = [newEvent.ID integerValue];
            }
            
            newCell.phoneButton.enabled = false; //TODO: Phone button has to be checked if valid and then enabled

            
            [newCell.facebookButton addTarget:self action:@selector(facebookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [newCell.websiteButton addTarget:self action:@selector(websiteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [newCell.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return newCell;
            
        }else{
            AgendaListeCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"AgendaListeCell"];
            
           EventItem *newEvent = [self.currentEventList  objectAtIndex:[indexPath row]];
           newCell.nameLabel.text = newEvent.title;
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components: NSMinuteCalendarUnit | NSHourCalendarUnit | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newEvent.startDate];

            newCell.dateLabel.font = [UIFont fontWithName:@"Lato-Hairline" size:38];
            newCell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)[components day]];
            newCell.monthLabel.font = [UIFont fontWithName:@"Lato-Hairline" size:16];
            newCell.monthLabel.text = [Utilities germanMonthFromNumber:[components month]];
            newCell.timeAndLocationLabel.text = [NSString stringWithFormat:@"%02d:%02d",[components hour],[components minute]];
            
            return newCell;
            
        }
    
    }else{
        
        FilterListeCell *newCell = [self.filterTableView dequeueReusableCellWithIdentifier:@"FilterListeCell"];
        
        // Distinguish between a location and "Alle". In the future, create classes to distinguish
        if([[self.currentFilterList objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
            newCell.txtLabel.text = [self.currentFilterList objectAtIndex:indexPath.row];
        }else{
            LocationItem *item = [self.currentFilterList objectAtIndex:indexPath.row];
            newCell.txtLabel.text = item.name;
        }

        return newCell;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    
    // Cancel detail cell selection in order to keep regular cell (above it) selected.
    if(tableView == self.tableView){
        if([[self.currentEventList objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
            return nil;
        }
    }
    
    return indexPath;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(tableView == self.tableView){
        
        AgendaListeCell *cell = (AgendaListeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSIndexPath *newIndexPath;
        
        cell.backgroundImage.image = [UIImage imageNamed:@"AgendaListeCellSelectedBackgroundImage"];

        // A Detail Cell Already Exists
        if([self.currentEventList containsObject:@"detail"]){
             
            // Remove the Detail Cell
            newIndexPath = [NSIndexPath indexPathForRow:[self.currentEventList indexOfObject:@"detail"] inSection:0];
            [self.currentEventList  removeObject:@"detail"];
            [self.tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
             
             //If the user pressed on the same cell, do not open another detail cell
             if([newIndexPath row] - 1 == [indexPath row]){
                 cell.backgroundImage.image = [UIImage imageNamed:@"AgendaListeCellBackgroundImage"];
                 return;
             }
         }
        
        //Add the Detail Cell under the original Cell
        [self.currentEventList insertObject:@"detail" atIndex: [[self.tableView indexPathForCell:cell] row] + 1];
        NSIndexPath *newDetailCellIndexPath = [NSIndexPath indexPathForRow:[[self.tableView indexPathForCell:cell] row] + 1 inSection:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newDetailCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    // Filter is Applied
    if(tableView == self.filterTableView){
        
        FilterListeCell *cell = (FilterListeCell *)[self.filterTableView cellForRowAtIndexPath:indexPath];
        
        // Change the background image to simulate highlighting
        cell.backgroundImageView.image = [UIImage imageNamed:@"DropDownFilterButtonSelected-568"];
        [self performSelector:@selector(changeFilterCellImageBack:)withObject:indexPath afterDelay:0.5];
        
        // Filter cell selected is the dummy object "Alle ausgewahlt"
        if([[self.currentFilterList objectAtIndex:[indexPath row]] isKindOfClass:[NSString class]]){
            
             [self.currentFilterList removeObject:@"Alle ausgewählt"];
            [self.currentFilterList addObject:self.currentLocationFilter];
            self.currentLocationFilter = nil;
            [self.filterButtonTextLabel setText: @"Alle ausgewählt"];
            
            NSArray *sortedEvents = [self.events sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first  = [(EventItem*)a startDate];
                NSDate *second = [(EventItem*)b startDate];
                return [first compare:second];
            }];
            
            NSArray *sortedFilter = [self.locations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first  = [(LocationItem*)a name];
                NSString*second = [(LocationItem*)b name];
                return [first caseInsensitiveCompare:second];
            }];
            
            self.currentFilterList = [sortedFilter mutableCopy];
            
            self.currentEventList = [sortedEvents mutableCopy];
            
        }else{
            LocationItem *filterLocation = [self.currentFilterList objectAtIndex: [indexPath row]];
            
              if(self.currentLocationFilter){
                  [self.currentFilterList addObject:self.currentLocationFilter];
                   self.currentLocationFilter = filterLocation;
                   self.filterButtonTextLabel.text = self.currentLocationFilter.name;
                  [self.currentFilterList removeObjectAtIndex:[indexPath row]];
                  
              }else{
                  self.currentLocationFilter = filterLocation;
                  self.filterButtonTextLabel.text = self.currentLocationFilter.name;
                  
                  [self.currentFilterList removeObjectAtIndex:[indexPath row]];
                  
                  NSMutableArray *newFilterList = [[NSMutableArray alloc] init];
                  [newFilterList addObject:@"Alle ausgewählt"]; // Dummy string acting as placeholder
                  
                  NSArray *sortedFilter = [self.currentFilterList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                      NSString *first  = [(LocationItem*)a name];
                      NSString*second = [(LocationItem*)b name];
                      return [first caseInsensitiveCompare:second];
                  }];

                  [newFilterList addObjectsFromArray:sortedFilter];
                  self.currentFilterList = newFilterList;
              }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clubReferenceID==%@",filterLocation.ID];
            self.currentEventList = [[self.events filteredArrayUsingPredicate:predicate] mutableCopy];
        }
        
        [self.tableView reloadData];
        [self filterButtonPressed:nil]; // Close the filter dropdown
    }
}

// Changes filter cell image back to default image
-(void)changeFilterCellImageBack:(NSIndexPath*)path{
    FilterListeCell *cell = (FilterListeCell *)[self.filterTableView cellForRowAtIndexPath:path];
    cell.backgroundImageView.image = [UIImage imageNamed:@"CellBackgroundDark"];
}

- (void) tableView: (UITableView *) tableView didDeselectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(tableView == self.tableView){
        AgendaListeCell *cell = (AgendaListeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundImage.image = [UIImage imageNamed:@"AgendaListeCellBackgroundImage"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.filterTableView){
        return FILTER_TABLEVIEW_ROW_HEIGHT ;
    }
    
    // If the object is a string, then it is the dummy object corresponding to the Detail Cell
    return ([[self.currentEventList objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) ? AGENDA_TABLEVIEW_DETAIL_ROW_HEIGHT : AGENDA_TABLEVIEW_NORMAL_ROW_HEIGHT;
}

-(void)openFilterView{
    isFilterViewOpen = true;
}

-(void)closeFilterView{
    isFilterViewOpen = false;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)facebookButtonPressed:(id)sender {
    
    
    UIButton *button = (UIButton*)sender;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID==%d",button.tag];

    EventItem *eventItem = [self.events filteredArrayUsingPredicate:predicate][0];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"fb:%@",eventItem.facebookURL]];
    
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:url];
    
    if(isInstalled){
        [[UIApplication sharedApplication]  openURL: url];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:eventItem.facebookURL]];
    }
}

- (IBAction)websiteButtonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID==%d",button.tag];
    EventItem *eventItem = [self.events filteredArrayUsingPredicate:predicate][0];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:eventItem.siteURL]];
}

- (IBAction)phoneButtonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID==%@",button.tag];
    LocationItem *location = [self.locations filteredArrayUsingPredicate:predicate][0];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"telprompt:%@",location.phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
