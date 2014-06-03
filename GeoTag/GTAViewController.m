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

#import <MapKit/MapKit.h>

#import "MAPAnnotation.h"

@interface GTAViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@end

@implementation GTAViewController
{
    
    
    MKMapView * myMapView;

    
    
    CLLocationManager * lManager;
    
    UITableView * enemies;
    
    
    //NSMutableArray * enemiesInProximity;
    
    //NSArray * enemyProfiles;
    
    CLLocation * currentLocation;
    CLLocation * lastLocation;
    
    
    UIButton * mineWasTrippedTest;
    
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
        
        //////MAP/////////
        //sets marker to current location
        MAPAnnotation * annotation = [[MAPAnnotation alloc]initWithCoordinate:location.coordinate];
        
        //adds marker to mapView
        [myMapView addAnnotation:annotation];
        
        //moves map to center on current location
        [myMapView setCenterCoordinate:location.coordinate animated:YES];
        
        //Will move map to current region
        //MKCoordinateRegion region = mapView.region;
        
        //specifies where & how much to zoom in
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1.0, 1.0));
        
        //Set custom subtitles like callSign+mine
        //annotation.title = @"Title";
        //annotation.subtitle = @"Subtitle";
        
        region.span = MKCoordinateSpanMake(0.08, 0.08);
        
        [myMapView setRegion:region animated:YES];
        

        ////////MAP//////////
        
        
        
        
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

            PFQuery * mineQuery = [PFQuery queryWithClassName:@"MineLocationLog"];
            [mineQuery orderByDescending:@"createdAt"];
            [mineQuery whereKey:@"parent" notEqualTo:[PFUser currentUser]];
            [mineQuery whereKey:@"LocationOfMine" nearGeoPoint:geoPoint withinKilometers:1];
            [mineQuery whereKey:(@"updatedAt") greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:-60 * 2]];
            
            [mineQuery findObjectsInBackgroundWithBlock:^(NSArray *mineObjects, NSError *error)
             {
                 NSLog(@"User searching for Mine : %@",mineObjects);

                 for (PFObject * isMineThere in mineObjects)
                 {
                     PFUser * parent = isMineThere[@"parent"];
                     
                     if ((parent != [PFUser currentUser][@"parent"])) //&& (parent != nil))
                 
                     {
                     [self tripMine];

                 }
                 else
                 {
                     return;
                 }
                 };
             
             
             
             
             }];
            
            
            
            
            
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
                    
                    [parent fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        
                    
                        PFUser * callSign = (PFUser *)object[@"callSign"];
                        
                        NSLog(@"%@", callSign);

                        
                        // singleton add user to mutable array
                        //Adding object to mutable array of enemies in proximity
                        [[GTASingleton sharedData].enemiesInProximity addObject:object];
                        
                        
                        // trigger tableview to reload
//                        NSArray * newEnemies = [GTASingleton sharedData].enemiesInProximity;
//                        [gtaTVC.tableView addConstraints:newEnemies];
                        
                        [gtaTVC.tableView reloadData];
                        
                        
                        
                        
                        
                        //this will search the enemiseInProximity array for duplicates
//                        if (![[GTASingleton sharedData].enemiesInProximity containsObject:object])
//                            [[GTASingleton sharedData].enemiesInProximity addObject:object];

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


-(void)tripMine
{
    mineWasTrippedTest = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    mineWasTrippedTest.backgroundColor = [UIColor redColor];
    [self.view addSubview:mineWasTrippedTest];
    
}





-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

////////layMineButton///////////
//    layMineButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 75, 30, 30)];
//    layMineButton.backgroundColor = [UIColor blueColor];
//    layMineButton.layer.cornerRadius = 15;
//    [layMineButton addTarget:self action:@selector(layMine) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:layMineButton];
    
    
    
    myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(60, 50, 200,200)];
    
    myMapView.delegate = self;
    
    [self.view addSubview:myMapView];
    
    
    

    targets = [[UITableView alloc]initWithFrame:CGRectMake(-3, ((SCREEN_HEIGHT / 5)*3), self.view.frame.size.width, (SCREEN_HEIGHT/2))];
    [targets addSubview:gtaTVC.view];
    
    
    
    
    
    
    //gtaTVC = [[GTATableViewController alloc]initWithNibName:nil bundle:nil];
//    gtaTVC = [[GTATableViewController alloc]initWithStyle:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ((SCREEN_HEIGHT / 3)*2))];
    //[self.view addSubview:gtaTVC];
    
    
    // Do any additional setup after loading the view.
}







//////////touch to drop mine////////////////
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    if (annotationView == nil)
    {
        //initializing and defining the info within the annotationView (the info) ***always need an annotation, don't necessarily always need an annotationView***
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    } else {
        //reset annotationView property to new annotation location
        annotationView.annotation = annotation;
    }
    
    //Make your pin a specific picture
    //annotationView.image = [UIImage imageNamed:@"NAME OF IMAGE FILE"];
    
    annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"%@", view.annotation.title);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    //CLLocation * pinLocation;
    
    
    for (UITouch * touch in touches)
    {
        
        CGPoint location = [touch locationInView:myMapView];
        
        CLLocationCoordinate2D coordinate = [myMapView convertPoint:location toCoordinateFromView:myMapView];
        
        
        //moves map to center on current location
        [myMapView setCenterCoordinate:coordinate animated:YES];
        
        
        //sets marker to current location
        MAPAnnotation * annotation = [[MAPAnnotation alloc]initWithCoordinate:coordinate];
        
        //adds marker to mapView
        [myMapView addAnnotation:annotation];
        
        
        
        
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
        CLLocation * newMineLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        [geoCoder reverseGeocodeLocation:newMineLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             
             //NSLog(@"%@", placemarks);
//             
//             for (CLPlacemark * placemark in placemarks)
//             {
             
                 //NSLog(@"%@",placemark.country);
                 
                 //setting cityState variable to City and State for respective keys for annotation
//                 NSString * cityState = [NSString stringWithFormat:@"%@, %@",placemark.addressDictionary[@"City"],placemark.addressDictionary[@"State"]];
//                 
//                 [annotation setTitle:cityState];
//                 
//                 [annotation setTitle:placemark.country];
                 
                 
                 
                 
                 ////log mine in Parse
                 PFObject * mineLocation = [PFObject objectWithClassName:@"MineLocationLog"];
                 //CLLocationCoordinate2D coordinate = [location coordinate];
                 PFGeoPoint * geoPoint = [PFGeoPoint geoPointWithLatitude:newMineLocation.coordinate.latitude
                                                                longitude:newMineLocation.coordinate.longitude];
                 //PFGeoPoint * gpLatitude = [PFGeoPoint location.coordinate.latitude];
                 mineLocation[@"parent"]= [PFUser currentUser];
                 mineLocation[@"LocationOfMine"] = geoPoint;
                 //userLocation[@"Latitude"] = currentLocation.coordinate.latitude;
                 //            mineLocation[@"Country"] =
                 //            mineLocation[@"State"] =
                 //            mineLocation[@"City"] =
                 [mineLocation saveInBackground];
                 
                 
                 PFQuery * query =[PFQuery queryWithClassName:@"UserLocationLog"];
                 [query orderByDescending:@"createdAt"];
                 [query whereKey:@"parent" notEqualTo:[PFUser currentUser]];
                 [query whereKey:@"CurrentLocation" nearGeoPoint:geoPoint withinKilometers:1];
                 [query whereKey:(@"updatedAt") greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:-60 * 2]];
                 
                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                  {
                      
                      if (objects != nil)
                      {
                          [self tripMine];
                          
                      }
                      else
                      {
                          return;
                      }
                      
                      
                      
                      
                      NSLog(@"Mine searching for user : %@",objects);
                  }];
                 
             //}
         }];
        
    }
}

//////////touch to drop mine//////////////



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
