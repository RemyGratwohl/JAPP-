//
//  psHomeViewController.h
//  ToDoList
//
//  Created by Patrik on 20.11.13.
//  Copyright (c) 2013 Patrik. All rights reserved.
//

#import "psHomeViewController.h"
#import "psClubContentViewController.h"
#import "psAlarmViewController.h"
#import "psMenuItem.h"
#import "psClubTabViewController.h"
#import "psClockViewController.h"
#import "psTourViewController.h"
#import "psCardReaderViewController.h"


@interface psHomeViewController()


@end


@implementation psHomeViewController

@synthesize mainData;
//@synthesize menuItems;

static int IntroLimit = 10;
static int ArrowLimit = 6;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Localization
    self.label1.text = NSLocalizedString(@"Intro1", @"Welcome to Huber");
    self.label2.text = NSLocalizedString(@"Intro2", @"Home to ...");
    
    // Init TableView
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.hidden = TRUE;
    // As this is no a TableViewController, but a ViewController
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // This is for omiting the the separator in empty cells
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:tempView];
    
    // Used to trigger saving
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillGoToBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    
    // Inital drop down menu, which is a table
    [self loadMenu];
    
    // Load the application data through DataManager (which is stateless)
    psDataManager* dataMgr =[ [psDataManager alloc] init];
    if(dataMgr.existsUserData)
    {
        mainData = [dataMgr loadUserData];
        
    }
    else {
        mainData = [dataMgr loadUserTestData];
    }

    // Network connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.sitewalk.com" ]; // @"www.google.ch"
	[self.hostReachability startNotifier];

    
    // Intro
    [self loadIntroImages];
    
    // Do an intital transition befor it gets called by the timer
    [self doImageTransition];
    
    [self startIntroTimer];
    [self startArrowTimer];
    
    self.label1.font = [psCommon getLeitureNewsFont:24];
    self.label2.font = [psCommon getLeitureNewsFont:24];
    [self doTextTransition];
    
  
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Update Mail indication
    [self updateMailCounterLabels];
    [self.tableView reloadData];
    
    // Timers
    if(self.timerIntro==nil) {
        [self doImageTransition];
        [self startIntroTimer];
    }
    
}

-(void)appWillGoToBackground:(NSNotification *)note {
 
    // Stop Timer
    [self stopIntroTimer];
    [self stopArrowTimer];

    
    if(mainData.updateDataToServer || mainData.updateNewsletter) {

        NetworkStatus remoteHostStatus = [self.hostReachability currentReachabilityStatus];
        psServerManager* server =[ [psServerManager alloc] init];
        
        // Save data to the server, this needs net connection ...
        if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            
            if(mainData.updateNewsletter) {
                BOOL updated = false;
                
                if(mainData.adressItem.Newsletter) {
                    updated = [server registerUserToMailChimp:mainData.adressItem];
                }
                else {
                    
                    updated = [server deRegisterUserFromMailChimp:mainData.adressItem];
                }
                
                if(updated)
                    mainData.updateNewsletter = false;
            }
            
            if(mainData.updateDataToServer) {
                [server saveUserData:mainData];
            }
            
        }
    }

    
    // Finally, save user data locally
    psDataManager* dataMgr =[ [psDataManager alloc] init];
    [dataMgr saveUserData:mainData];

    
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Stop Timer
    [self stopIntroTimer];
    [self stopArrowTimer];
    
}

- (void)viewDidLayoutSubviews
{
    // Workaround, move intro images further down if screen size is larger
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight > IPhone4Size) {
        
        [self moveDownBy:30 view:self.imageView1];
        [self moveDownBy:30 view:self.imageView2];
        
        [self moveDownBy:40 view:self.label1];
        [self moveDownBy:40 view:self.label2];
        
    }
    
}

-(void) moveDownBy:(int) add_y view:(UIView*) viewMove {
    
    CGRect myFrame = viewMove.frame;
    myFrame.origin.x = myFrame.origin.x;
    myFrame.origin.y = myFrame.origin.y + add_y;
    viewMove.frame = myFrame;
    
}

- (void) didFinishLoadingMails:(NSMutableArray *)mails {
    
    // Put to user data
    [mainData activateMails:mails];
    [mainData sortMails];
    
    // Update Mail indication
    [self updateMailCounterLabels];
    [self.tableView reloadData];
}


- (void) didFinishLoadingSearchImages:(NSMutableArray *)images {
    
    // No need to react on this
    
}

- (void)updateMailCounterLabels {
    
    int newMails = [mainData countUnreadMails];
    
    if(newMails > 0) {
        self.labelMail.hidden = false;
        self.iconMail.hidden = false;
        self.labelMail.text = [NSString stringWithFormat:@"%d", newMails];
    }
    else {
        self.labelMail.hidden = true;
        self.iconMail.hidden = true;
        self.labelMail.text = @"";
    }
}



- (void)networkChanged:(NSNotification *)notification
{
    
    NetworkStatus remoteHostStatus = [self.hostReachability currentReachabilityStatus];
 
    psServerManager* server =[ [psServerManager alloc] init];
    server.delegate = self;
 

    // Get mails if either Wifi or GSM/Edge/... connected
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"No connection to sitewalk.com host possible");
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
       if(mailCheckCounters==0)
           [server doLoadNewsFromServer];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        if(mailCheckCounters==0)
            [server doLoadNewsFromServer];
    }
    
    // Count up, and go back to 0 when 1 (2) is reached
    mailCheckCounters++;
    if(mailCheckCounters==1)
        mailCheckCounters = 0;
}


- (IBAction)buttonCancelClick:(id)sender {
    
    psDataManager* dataMgr =[ [psDataManager alloc] init];
    mainData = [dataMgr loadUserTestData];
    
    NSLog(@"User data reset!");
    
}


- (IBAction)backgroundClicked:(id)sender {
    
    self.tableView.hidden = true;
    
}

- (IBAction)menuClicked:(id)sender {

    // Update Mail indication
    [self.tableView reloadData];
    
    // Show
    self.tableView.hidden = ! self.tableView.hidden;
    
    // Deactivate arrows
    mainData.menuCounter++;
    [self hideArrows];
    [self stopArrowTimer];

}


//timer intro callback
- (void) updateIntro:(NSTimer *)theTimer{
    
    introIndex++;
    if(introIndex >= IntroLimit) introIndex = 0;
    alphaSwitch = !alphaSwitch;
    
    [self doImageTransition];
    
}

-(void) loadIntroImages {
    
    // Preload images to improve performance
    introImages = [[NSMutableArray alloc] init];
    [introImages addObject:[UIImage imageNamed:@"intro0.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro1.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro2.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro3.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro4.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro5.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro6.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro7.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro8.png"]];
    [introImages addObject:[UIImage imageNamed:@"intro9.png"]];
    
}


//timer arrows callback
- (void) updateArrows:(NSTimer *)theTimer{
    
    arrowIndex++;
    if(arrowIndex >= ArrowLimit) {
        arrowIndex = 0;
        arrowSwitch = ! arrowSwitch;
    }

    [self hideArrows];
    
    if (!arrowSwitch) {
    
        if(arrowIndex==0)
            self.imageArrow6.hidden = false;
        else if(arrowIndex==1)
            self.imageArrow5.hidden = false;
        else if(arrowIndex==2)
            self.imageArrow4.hidden = false;
        else if(arrowIndex==3)
            self.imageArrow3.hidden = false;
        else if(arrowIndex==4)
            self.imageArrow2.hidden = false;
        else if(arrowIndex==5)
            self.imageArrow1.hidden = false;
    }
    else {
        
        if(arrowIndex==5)
            self.imageArrow6.hidden = false;
        else if(arrowIndex==4)
            self.imageArrow5.hidden = false;
        else if(arrowIndex==3)
            self.imageArrow4.hidden = false;
        else if(arrowIndex==2)
            self.imageArrow3.hidden = false;
        else if(arrowIndex==1)
            self.imageArrow2.hidden = false;
        else if(arrowIndex==0)
            self.imageArrow1.hidden = false;
        
    }
   
}

- (void) hideArrows {
  
    self.imageArrow1.hidden = true;
    self.imageArrow2.hidden = true;
    self.imageArrow3.hidden = true;
    self.imageArrow4.hidden = true;
    self.imageArrow5.hidden = true;
    self.imageArrow6.hidden = true;
    
}

- (void) doTextTransition {
    
    self.label1.alpha = 0;
    self.label2.alpha = 0;
    
    [UIView transitionWithView:self.label1 duration:7.0f options:UIViewAnimationOptionTransitionCrossDissolve
        animations:^{ self.label1.alpha = 1;} completion:nil];
    
    [UIView transitionWithView:self.label2 duration:9.0f options:UIViewAnimationOptionTransitionCrossDissolve
        animations:^{ self.label2.alpha = 1;} completion:nil];
    
}

- (void) doImageTransition {
    
    float alpha1 = 1.0;
    float alpha2 = 0.0;
    
    // Do either transiation from View1 -> View2 or View2 -> View1
    if(alphaSwitch) {
        alpha1 = 0.0;
        alpha2 = 1.0;
    }
    
    self.imageView1.image = [introImages objectAtIndex:introIndex];
    self.imageView1.alpha = alpha1;
    
    int introIndex2 = introIndex;
    if(introIndex2 > IntroLimit)
        introIndex2 = 0;
    
    self.imageView2.image = [introImages objectAtIndex:(introIndex2)];
    self.imageView2.alpha = alpha2;
    
    [UIView transitionWithView:self.imageView1 duration:7.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.imageView1.alpha = alpha2;} completion:nil];
    
    [UIView transitionWithView:self.imageView2 duration:7.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.imageView2.alpha = alpha1;} completion:nil];
    
}

- (void) startIntroTimer {
    
    if(self.timerIntro==nil) {
        self.timerIntro = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(updateIntro:) userInfo:nil repeats:YES];
    }
    
}

- (void) startArrowTimer {
    
    
    if(self.timerArrows==nil && mainData.menuCounter < 4) {
        self.timerArrows = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateArrows:) userInfo:nil repeats:YES]; // Old 0.4
    }
    
}

- (void) stopIntroTimer {
    
    if(self.timerIntro!=nil)
        [self.timerIntro invalidate];
 	self.timerIntro = nil;
 
}

- (void) stopArrowTimer {
    
    if(self.timerArrows!=nil)
        [self.timerArrows invalidate];
 	self.timerArrows = nil;
    
}

- (void)loadMenu {

    menuItems = [[NSMutableArray alloc] init];

    psMenuItem *item1 = [[psMenuItem alloc] init];
    item1.menuType = psMenuItemTypeClub;
    item1.itemName = NSLocalizedString(@"DropDownClub", @"Huber Club");
    [menuItems addObject:item1];
    
    psMenuItem *item2 = [[psMenuItem alloc] init];
    item2.menuType = psMenuItemTypeAlarm;
    item2.itemName = NSLocalizedString(@"DropDownWatch", @"Uhr");
    [menuItems addObject:item2];
    
    psMenuItem *item3 = [[psMenuItem alloc] init];
    item3.menuType = psMenuItemTypeCard;
    item3.itemName = NSLocalizedString(@"DropDownReader", @"Visitenkarten-Reader");
    //[menuItems addObject:item3]; // Acitve later
    
    psMenuItem *item4 = [[psMenuItem alloc] init];
    item4.menuType = psMenuItemTypeTour;
    item4.itemName = NSLocalizedString(@"DropDownTour", @"Walking Tour Vaduz");
    [menuItems addObject:item4];
    
    // Release possibly needed
    // [item1 release];
    
}


- (void)accountUnlocked {
    
     [self.tableView reloadData];
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))compl {
    
    [self stopIntroTimer];
    [self stopArrowTimer];
	[super dismissViewControllerAnimated:flag completion:compl];
}


#pragma mark - Table view data source

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    psMenuItem *tabItem = [menuItems objectAtIndex:indexPath.row];

    [self stopIntroTimer];
    [self stopArrowTimer];

    if(tabItem.menuType == psMenuItemTypeClub) {
        [self performSegueWithIdentifier:@"selectMenuClub" sender:self];
    }
    else if(tabItem.menuType == psMenuItemTypeAlarm) {
        [self performSegueWithIdentifier:@"selectMenuClock" sender:self];
    }
    else if(tabItem.menuType == psMenuItemTypeTour) {
        [self performSegueWithIdentifier:@"selectMenuTour" sender:self];
    }
    else if(tabItem.menuType == psMenuItemTypeCard) {
        [self performSegueWithIdentifier:@"selectMenuCardReader" sender:self];
    }
    
}


//- (void) didFinishEnteringPhoto:(UIImage *)item {
//
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    psMenuItem *item = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemName;

    UIImageView *ivLock = (UIImageView *)[cell viewWithTag:101];
    UIImageView *ivNumberIcon = (UIImageView *)[cell viewWithTag:102];
    UILabel *ivNumberText = (UILabel *)[cell viewWithTag:103];
    
    // Show lock in cell (if club is still locked)
    if(!mainData.isUnlocked && item.menuType == psMenuItemTypeClub)
        ivLock.hidden = false;
    else
        ivLock.hidden = true;
    
    int newMails = [mainData countUnreadMails];
    
    if(newMails > 0 && item.menuType == psMenuItemTypeClub) {
        ivNumberText.hidden = false;
        ivNumberIcon.hidden = false;
        ivNumberText.text = [NSString stringWithFormat:@"%d", newMails];
    }
    else {
        ivNumberIcon.hidden = true;
        ivNumberText.hidden = true;
        ivNumberText.text = @"";
    }
    
    return cell;
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectMenuClub"])
    {
        psClubTabViewController *detailVC = [segue destinationViewController];
        detailVC.mainData =  mainData;
        detailVC.delegate = self;
        
        detailVC.hostReachability = self.hostReachability;
       
        
    } else if ([[segue identifier] isEqualToString:@"selectMenuClock"])
    {
        psClockViewController *detailVC = [segue destinationViewController];
        detailVC.mainData =  mainData;
    } else if ([[segue identifier] isEqualToString:@"selectMenuTour"])
    {
        psTourViewController *detailVC = [segue destinationViewController];
        detailVC.mainData =  mainData;
    }
    
    // Hide menu
    //self.tableView.hidden = TRUE;
}


- (void)dealloc
{
	[self stopIntroTimer];
    [self stopArrowTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
