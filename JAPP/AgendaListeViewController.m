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

@interface AgendaListeViewController ()

@end

@implementation AgendaListeViewController


// CONSTANTS
const float FILTER_TABLEVIEW_ROW_HEIGHT        = 33.0;
const float AGENDA_TABLEVIEW_NORMAL_ROW_HEIGHT = 62.0;
const float AGENDA_TABLEVIEW_DETAIL_ROW_HEIGHT = 134.0;

bool isFilterViewOpen = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.tableView setContentInset:UIEdgeInsetsMake(2,0,0,0)];

    // Register Nibs for Cells
    [self.tableView       registerNib: [UINib nibWithNibName:@"AgendaListeDetailCell" bundle:nil] forCellReuseIdentifier:@"AgendaListeDetailCell"];
    [self.tableView       registerNib: [UINib nibWithNibName:@"AgendaListeCell" bundle:nil]       forCellReuseIdentifier:@"AgendaListeCell"];
    [self.filterTableView registerNib: [UINib nibWithNibName:@"FilterListeCell" bundle:nil]       forCellReuseIdentifier:@"FilterListeCell"];
    
}

- (IBAction)filterButtonPressed:(id)sender {
    
    //Animate the filterTableView to create a dropdown effect
    //Disable button so multiple animations can not occur
    self.filterButton.enabled = false;
    
    [UIView animateWithDuration:0.5
                              delay:0.00
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{

                             if (!isFilterViewOpen){
                                
                                 self.filterTableView.hidden = false;
                                 [self.filterButton setImage:[UIImage imageNamed:@"DropDownFilterButtonActive-568"] forState:UIControlStateNormal];

                                 int newHeight = self.filterTableView.frame.origin.y + [self.locations count] * FILTER_TABLEVIEW_ROW_HEIGHT;
                                 //32
                                 [self changeHeightOf : self.filterTableView to: newHeight];
                                 int newTableViewHeight = self.filterTableView.frame.origin.y + [self.locations count] * FILTER_TABLEVIEW_ROW_HEIGHT;
                                 //458
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
                                 
                                 //Make sure animation did occur
                                 
                                 int newHeight = self.filterTableView.frame.origin.y + [self.locations count] * FILTER_TABLEVIEW_ROW_HEIGHT;
                                 //32
                                 [self changeHeightOf : self.filterTableView to: newHeight];
                                 int newTableViewHeight = self.filterTableView.frame.origin.y + [self.locations count] * FILTER_TABLEVIEW_ROW_HEIGHT;
                                 //458
                                 [self changeYOriginOf: self.tableView       to: newTableViewHeight];
                                 
                             }else if (finished && isFilterViewOpen){
                                 [self closeFilterView];
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
    if(tableView == self.tableView){
        return [self.events count];
    }else{
        return [self.locations count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableView){
        if([[self.events objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
            
            AgendaListeDetailCell *newCell;
            EventItem *newEvent = [self.events objectAtIndex:[indexPath row] - 1];

        
            newCell = [tableView dequeueReusableCellWithIdentifier:@"AgendaListeDetailCell"];
            
            //if([newEvent.siteURL length] == 0){
                newCell.facebookButton.enabled = false;
           // }
            
            newCell.descriptionLabel.text = newEvent.descript;
            
            return newCell;
        }else{
            AgendaListeCell *newCell;
            newCell = [tableView dequeueReusableCellWithIdentifier:@"AgendaListeCell"];
            
           EventItem *newEvent = [self.events objectAtIndex:[indexPath row]];
            newCell.nameLabel.text = newEvent.title;
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newEvent.startDate];

            newCell.dateLabel.text = [NSString stringWithFormat:@"%d",[components day]];
           // newCell.dateLabel.text = newEvent.date;
           // newCell.timeAndLocationLabel.text = [NSString stringWithFormat:@"%@, %@",newEvent.time,newEvent.location];
            
            
            return newCell;
            
        }
    
    }else{
        
        FilterListeCell *newCell = [self.filterTableView dequeueReusableCellWithIdentifier:@"FilterListeCell"];
        LocationItem *item = [self.locations objectAtIndex:indexPath.row];
        newCell.txtLabel.text = item.name;
        return newCell;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    
    if([[self.events objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
        return nil;
    }
    
    return indexPath;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(tableView == self.tableView){
        
        //Grab Cell that was clicked on
        AgendaListeCell *cell = (AgendaListeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        NSIndexPath *newIndexPath;
        
        cell.backgroundImage.image = [UIImage imageNamed:@"AgendaListeCellSelected-568"];

        if([self.events containsObject:@"detail"]){
             
             // Remove Detail Cell
            newIndexPath = [NSIndexPath indexPathForRow:[self.events indexOfObject:@"detail"] inSection:0];
            [self.events removeObject:@"detail"];
            [self.tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
             
             //If the user pressed on the same cell, do not open another detail cell
             if([newIndexPath row] - 1 == [indexPath row]){
                 cell.backgroundImage.image = [UIImage imageNamed:@"Agenda_Cell-568"];
                 return;
             }
         }
        
        //Add the Detail Cell under the original Cell
 
        
        
        
        [self.events insertObject:@"detail" atIndex: [[self.tableView indexPathForCell:cell] row] + 1];
        NSIndexPath *newDetailCellIndexPath = [NSIndexPath indexPathForRow:[[self.tableView indexPathForCell:cell] row] + 1 inSection:0];
        [self.tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newDetailCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    }
    
    if(tableView == self.filterTableView){
        FilterListeCell *cell = (FilterListeCell *)[self.filterTableView cellForRowAtIndexPath:indexPath];
        cell.backgroundImageView.image = [UIImage imageNamed:@"DropDownFilterButtonSelected-568"];
        [self.filterButtonTextLabel setText:cell.txtLabel.text];
        [self filterButtonPressed:nil];
    }
    
}

- (void) tableView: (UITableView *) tableView didDeselectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(tableView == self.filterTableView){
        FilterListeCell *cell = (FilterListeCell *)[self.filterTableView cellForRowAtIndexPath:indexPath];
        cell.backgroundImageView.image = [UIImage imageNamed:@"DropDownFilterButtonActive-568"];
        
    }else{
        AgendaListeCell *cell = (AgendaListeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundImage.image = [UIImage imageNamed:@"Agenda_Cell-568"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.filterTableView){
        return FILTER_TABLEVIEW_ROW_HEIGHT ;
    }
    
    if([[self.events objectAtIndex:indexPath.row] isKindOfClass:[@"" class]]){
        return AGENDA_TABLEVIEW_DETAIL_ROW_HEIGHT;
    }else{
        return AGENDA_TABLEVIEW_NORMAL_ROW_HEIGHT;
    }
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
