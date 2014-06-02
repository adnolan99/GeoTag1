//
//  GTAViewController.m
//  GeoTag
//
//  Created by Austin Nolan on 5/23/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTAViewController.h"

#import "GTATableViewController.h"

#import "GTASingleton.h"

#import <CoreLocation/CoreLocation.h>

@interface GTAViewController () <CLLocationManagerDelegate>

@end

@implementation GTAViewController
{
    
    
    
    
    
    CLLocationManager * lManager;
    
    UITableView * enemies;
    
    
    //NSMutableArray * enemiesInProximity;
    
    //NSArray * enemyProfiles;
    
    CLLocation * currentLocation;
    CLLocation * lastLocation;
    
    
    UIButton * fakeRadar;
    
    UIView * targets;
    
    GTATableViewController * gtaTVC;
    

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
      
        
        
        
        
        
        
        gtaTVC = [[GTATableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        
        [UITableView animateWithDuration:0.2 animations:^{
            gtaTVC.view.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height);
        }];
        [self.navigationController pushViewController:gtaTVC animated:YES];
//        self.navigationController.toolbarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
        
        
        [self.view addSubview:gtaTVC.view];
        
        
        
        [GTASingleton sharedData].enemiesInProximity = [@[] mutableCopy];
        
        
        
        lManager = [[CLLocationManager alloc]init];
        
        lManager.delegate = self;
        
        lManager.distanceFilter = 1;
        lManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [lManager startUpdatingLocation];
        
        
        
//        This is a hardcoded test user
//        CLLocation * testUser1Location = [[CLLocation alloc]initWithLatitude:37.788 longitude:-122.409];
//        CLGeocoder * geoCoder1 = [[CLGeocoder alloc]init];
//
//        
//        
//        [geoCoder1 reverseGeocodeLocation:testUser1Location completionHandler:^(NSArray * friendly1, NSError *error)
//         {
//             //NSLog(@"This is testUser1Location %@", friendly1);
//             
//         }];
        
        // Custom initialization
    }
    return self;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    lastLocation = currentLocation;
    NSLog(@"lastLocation : %@", lastLocation);
    for (CLLocation * location in locations)
    {
        currentLocation = location;
        NSLog(@"currentLocation : %@", currentLocation);
        CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             NSLog(@"actualLocation : %@", location);
        if (lastLocation != currentLocation)
        {
            PFObject * userLocation = [PFObject objectWithClassName:@"UserLocationLog"];
            //CLLocationCoordinate2D coordinate = [location coordinate];
            PFGeoPoint * geoPoint = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                                          longitude:location.coordinate.longitude];
            //PFGeoPoint * gpLatitude = [PFGeoPoint location.coordinate.latitude];
            userLocation[@"parent"]= [PFUser currentUser];
            userLocation[@"CurrentLocation"] = geoPoint;
            //userLocation[@"Latitude"] = currentLocation.coordinate.latitude;
//            userLocation[@"Country"] = 
//            userLocation[@"State"] =
//            userLocation[@"City"] =
            [userLocation saveInBackground];
            NSLog(@"Parse geoPoint : %@",geoPoint);

            //At this point must also query parse to see who is near new location
            PFQuery * query =[PFQuery queryWithClassName:@"UserLocationLog"];
            [query orderByDescending:@"createdAt"];
            [query whereKey:@"parent" notEqualTo:[PFUser currentUser]];
            [query whereKey:@"CurrentLocation" nearGeoPoint:geoPoint withinKilometers:1.0];
            [query whereKey:(@"updatedAt") greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:-60 * 20]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                NSLog(@"%@",objects);
            
                //Need to cycle through objects array, and query parse for the objectId's that it retruns in order to get, the call sign, username, avatar
                
            
                for (PFObject * userLocation in objects)
                {
                    PFUser * parent = userLocation[@"parent"];
                    
//                    NSLog(@"%@",parent.objectId);
                    
                    [parent fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        
                        PFUser * user = (PFUser *)object;
                        
                        // singleton add user to mutable array
                        
//                        [GTASingleton sharedData].enemiesInProximity = user;
//                        
//                        [gtaTVC.view addConstraints:[GTASingleton sharedData].enemiesInProximity];
                        
                        // trigger tableview to reload
                        
                        
                        NSLog(@"%@", user);

                    }];
                    
                    
                    
                    
                    //Don't need this 2nd query b/c there is a built in way to retrive data, see fetch call above
//                    PFQuery * query2 = [PFQuery queryWithClassName:@"User"];
//                    [query2 getObjectInBackgroundWithId:parent.objectId block:^(PFObject * user, NSError *error)
//                    {
//                        // Do something with the returned PFObject in the gameScore variable.
//                        NSLog(@"%@", user);
//                    }];
                    
                    
                    
                    
                    
                    //[gtaTVC.view addConstraints:[GTASingleton sharedData].enemyProfiles];
                
                }
                [self.view addSubview:gtaTVC.view];
            }];
            
            
        }
        else
        {
            return;
        }
        
         }];
    }
}







-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    
    fakeRadar = [[UIButton alloc]initWithFrame:CGRectMake(60, 50, 200, 200)];
    fakeRadar.backgroundColor = [UIColor blueColor];
    fakeRadar.layer.cornerRadius = 100;
    [self.view addSubview:fakeRadar];
    
    
    
    
    
    
    
    targets = [[UITableView alloc]initWithFrame:CGRectMake(-3, ((SCREEN_HEIGHT / 5)*3), self.view.frame.size.width, (SCREEN_HEIGHT/2))];
    
    
    
    [targets addSubview:gtaTVC.view];
    
    
    
    
    
    
    //gtaTVC = [[GTATableViewController alloc]initWithNibName:nil bundle:nil];
//    gtaTVC = [[GTATableViewController alloc]initWithStyle:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ((SCREEN_HEIGHT / 3)*2))];
    //[self.view addSubview:gtaTVC];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
