//
//  TreffListeViewController.m
//  JAPP
//
//  Created by Remy Gratwohl on 13/06/14.
//
//

#import "TreffListeViewController.h"
#import "TreffListeCell.h"
#import "LocationItem.h"

@interface TreffListeViewController ()

@end

@implementation TreffListeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TreffListeCell" bundle:nil] forCellReuseIdentifier:@"TreffListeCell"];
    self.headerLabel.font = [UIFont fontWithName:@"Lato-Hairline" size:53];
    [self.tableView setContentInset:UIEdgeInsetsMake(1,0,0,0)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* TABLEVIEW */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.locationList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TreffListeCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"TreffListeCell"];
    
    LocationItem *item = [self.locationList objectAtIndex:indexPath.row];
    newCell.clubNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    newCell.clubNameLabel.text = [NSString stringWithFormat:@"%@, %@",item.name,item.place];
    
    return newCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    
    TreffListeCell *cell = (TreffListeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundImageView.image = [UIImage imageNamed:@"DropDownFilterButtonSelected-568"];

    return indexPath;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    
    [self performSelector:@selector(changeCellImage:)withObject:indexPath afterDelay:0.3];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openTreffDetailView" object:[self.locationList objectAtIndex:indexPath.row]];
    }];
    
}

-(void)changeCellImage:(NSIndexPath*)path{
     TreffListeCell *cell = (TreffListeCell *)[self.tableView cellForRowAtIndexPath:path];
     cell.backgroundImageView.image = [UIImage imageNamed:@"CellBackgroundDark"];
}

# pragma mark Button Handlers

- (IBAction)treffListeButtonPressed:(id)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hilfeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"openHilfePopUpView" object:nil];
    }];
}

- (IBAction)agendaButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAgendaView" object:nil];
    }];
}

@end
