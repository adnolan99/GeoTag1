//
//  GTAViewController.m
//  GeoTag
//
//  Created by Austin Nolan on 5/23/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTAViewController.h"

#import "GTATableViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface GTAViewController () <CLLocationManagerDelegate>

@end

@implementation GTAViewController
{
    
    
    
    
    
    CLLocationManager * lManager;
    
    UITableView * enemies;
    
    
    NSMutableArray * enemiesInProximity;
    
    NSArray * enemyProfiles;
    
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
        
        
        
//        [UITableView animateWithDuration:0.2 animations:^{
//            self.view.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//        [self.navigationController pushViewController:gtaTVC animated:YES];
//        self.navigationController.toolbarHidden = YES;
//        self.navigationController.navigationBarHidden = YES;
        
        
        
        
        
        enemiesInProximity = [@[] mutableCopy];
        
        
        lManager = [[CLLocationManager alloc]init];
        
        lManager.delegate = self;
        
        lManager.distanceFilter = 1;
        lManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [lManager startUpdatingLocation];
        
//        CLLocation * testUser1Location = [[CLLocation alloc]initWithLatitude:37.788 longitude:-122.409];
//        CLLocation * testUser2Location = [[CLLocation alloc]initWithLatitude:37.7878 longitude:-122.4088];
//        CLLocation * testUser3Location = [[CLLocation alloc]initWithLatitude:37.7876 longitude:-122.4086];
//        
//        CLGeocoder * geoCoder1 = [[CLGeocoder alloc]init];
//        CLGeocoder * geoCoder2 = [[CLGeocoder alloc]init];
//        CLGeocoder * geoCoder3 = [[CLGeocoder alloc]init];
//        
//        
//        [geoCoder1 reverseGeocodeLocation:testUser1Location completionHandler:^(NSArray * friendly1, NSError *error)
//         {
//             //NSLog(@"This is testUser1Location %@", friendly1);
//             
//         }];
//        
//        
//        [geoCoder2 reverseGeocodeLocation:testUser2Location completionHandler:^(NSArray * friendly2, NSError *error)
//         {
//             //NSLog(@"This is testUser2Location %@", friendly2);
//             
//         }];
//        
//        [geoCoder3 reverseGeocodeLocation:testUser3Location completionHandler:^(NSArray * friendly3, NSError *error)
//         {
//             //NSLog(@"This is testUser3Location %@", friendly3);
//             
//         }];
        
        
        
        // Custom initialization
    }
    return self;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    lastLocation = currentLocation;
    NSLog(@"lastLocation set from previous currentLocation... %@", lastLocation);

    for (CLLocation * location in locations)
    {
        currentLocation = location;
        NSLog(@"currentLocation pulled from actualLocation... %@", currentLocation);
    
        CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             NSLog(@"actualLocation in geo... %@", location);

         
        
        
        if (lastLocation != currentLocation)
        {
            
            PFObject * userLocation = [PFObject objectWithClassName:@"UserLocationLog"];
            
            //CLLocationCoordinate2D coordinate = [location coordinate];
            PFGeoPoint * geoPoint = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                                          longitude:location.coordinate.longitude];
            userLocation[@"CurrentLocaton"] = geoPoint;
            
            [userLocation saveInBackground];

            
            NSLog(@"Parse location = ... %@",location);
            NSLog(@"Parse currentLocation = ... %@",currentLocation);
            NSLog(@"Parse geoPoint = ... %@",geoPoint);

            
            
            
            //At this poin must also query parse to see who is near new location
            
            
            
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
