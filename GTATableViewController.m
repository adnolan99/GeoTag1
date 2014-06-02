//
//  GTATableViewController.m
//  GeoTag
//
//  Created by Austin Nolan on 5/23/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTATableViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "GTATableViewCell.h"

#import "GTASingleton.h"

#import <Parse/Parse.h>

@interface GTATableViewController () <CLLocationManagerDelegate>

@property UILabel * nameLabel;
@property UILabel * callSignLabel;

@end

@implementation GTATableViewController
{
    
    CLLocationManager * lManager;
    
    UITableView * enemies;

    
    //NSMutableArray * enemiesInProximity;
    
    //NSArray * enemyProfiles;
    
    NSArray * enemyProfilesArray;

    
    CLLocation * currentLocation;
    CLLocation * lastLocation;
    
    GTATableViewController * gtaTVC;

    UIImage * avatar;
    
    
    
//    UILabel * currentLocation;
    
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
//        
//        enemyProfilesArray = [GTASingleton sharedData].enemiesInProximity;
//
//        [self.view addConstraints:enemyProfilesArray];

        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    
    
    return [[GTASingleton sharedData].enemiesInProximity count];
}


//-(void)refreshEnemyProfileList
//{
//    [GTASingleton sharedData].enemyProfiles = [@[
//                                             @{@"CallSign":@"DynamicCallSign",@"Username":@"DynamicUsername",@"Distance":@"dynamicDistanceToEnemy",@"Avatar":@"dynamicUserAvatar"},]mutableCopy];
//
//    PFQuery * query =[PFQuery queryWithClassName:@"User"];
//    
//    //change order by created date
//    [query orderByDescending:@"createdAt"];
//    
//    //filter only your user's selfies
//    [query whereKey:@"parent" equalTo:[PFUser currentUser]];
//    //[query whereKey:(@"CurrentLocation") nearGeoPoint:(geoPoint) withinKilometers:currentLocation];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        
//        //enemyProfiles = objects;
//        
//        [self.tableView reloadData];
//        
//    }];
//    // change order by created date : newest first
//    // after user connected to selfy : filter only your user's selfies
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GTATableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) cell = [[GTATableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    

    
    
    
    
    //comment out, not sure what this is doing
    //[cell resetLayout];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //comment out, not sure what this is doing
    //cell.delegate = self;
    
    
    
    NSDictionary * enemy = [GTASingleton sharedData].enemiesInProximity[indexPath.row];
//
//    cell.textLabel.text = enemy[@"callSign"];
    
    
    cell.enemyProfile = enemy;
    
    
    
    
    
    self.tableView.rowHeight = 100;

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
