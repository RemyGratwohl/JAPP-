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
    
    if(self.locationList == NULL){
        NSLog(@"Location List is Null");
    }
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
    
    newCell.clubNameLabel.text = item.name;
    
    return newCell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    TreffListeCell *cell = (TreffListeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundImageView.image = [UIImage imageNamed:@"DropDownFilterButtonSelected-568"];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openTreffDetailView" object:[self.locationList objectAtIndex:indexPath.row]];
    }];
}

/* BUTTON HANDLERS */

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
