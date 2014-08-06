//
//  psToDoListViewController.h
//  ToDoList
//
//  Created by Patrik on 20.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "psUserData.h"
#import "psClubTabViewController.h"
#import "Reachability.h"
#import "psCommon.h"
#import "psServerManager.h"
#import "psDataManager.h"

@class psHomeViewController;

@interface psHomeViewController:  UIViewController<UITableViewDelegate, UITableViewDataSource, UnlockedViewDelegate, ServerLoadFinishedDelegate> {

@private
    int introIndex;
    int arrowIndex;
    BOOL arrowSwitch;
    BOOL alphaSwitch;
    int mailCheckCounters;
    
    NSMutableArray *menuItems;
    NSMutableArray *introImages;

}

@property (strong, nonatomic) psUserData *mainData;
@property (strong, nonatomic) Reachability *hostReachability;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *imageArrow1;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow2;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow3;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow4;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow5;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow6;

@property (weak, nonatomic) IBOutlet UILabel *labelMail;
@property (weak, nonatomic) IBOutlet UIImageView *iconMail;

@property NSTimer *timerIntro;
@property NSTimer *timerArrows;

- (IBAction)buttonCancelClick:(id)sender;

//- (IBAction)buttonClicked:(id)sender;

- (IBAction)backgroundClicked:(id)sender;

- (IBAction)menuClicked:(id)sender;


@end
