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

@interface GTAViewController () <CLLocationManagerDelegate, MKMapViewDelegate,GTATableViewControllerDelegate>

@property (nonatomic) BOOL minesToggled;

@property (nonatomic) BOOL rocketsToggled;

@property (nonatomic) BOOL attackModeActive;

@end

@implementation GTAViewController
{
    
    UIImageView * headerFrame;

    
    
    MKMapView * myMapView;

    CLLocationManager * lManager;
    
    UITableView * enemies;
    
    //NSMutableArray * enemiesInProximity;
    
    //NSArray * enemyProfiles;
    
    CLLocation * currentLocation;
    CLLocation * lastLocation;
    
    UIButton * mineWasTrippedTest;
    
    UIButton * testButton;

    UIButton * mines;
    UIButton * rockets;
    
    NSString * userScoreString;
    
    
    UIView * targets;
    
    GTATableViewController * gtaTVC;
    PFObject * userScore;
    
    //MAPAnnotation * mineAnnotation;
    
    UILabel * avEnemyCallsign;
    UILabel * avEnemyUsername;
    UILabel * avEnemyDistance;
    UILabel * avEnemyScore;
    UILabel * avEnemyLocation;

    
    UILabel * avUserCallsign;
    UILabel * avUserUsername;
    UILabel * avUserScore;
    UILabel * mineLabel;
    UILabel * rocketLabel;
    
    UIImageView * userAvatar;
    UIImageView * enemyAvatar;
    
    UIButton * backButton;
    
    
    CLLocationDistance enemyDist;
    
    
    
    MKCoordinateRegion region;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _minesToggled = NO;
        _rocketsToggled = NO;
        _attackModeActive = NO;
        
        gtaTVC = [[GTATableViewController alloc] initWithStyle:UITableViewStylePlain];
        gtaTVC.delegate = self;

        gtaTVC.tableView.frame = CGRectMake(0, 300, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 320);
        
//        [self.navigationController pushViewController:gtaTVC animated:YES];
//        self.navigationController.toolbarHidden = YES;
        
        [self.view addSubview:gtaTVC.tableView];
        
        [GTASingleton sharedData].enemiesInProximity = [@[] mutableCopy];
        
        lManager = [[CLLocationManager alloc]init];
        lManager.delegate = self;
        lManager.distanceFilter = 1;
        lManager.desiredAccuracy = kCLLocationAccuracyBest;
        [lManager startUpdatingLocation];
        
        userScore = [PFObject objectWithClassName:@"UserPointsLog"];
        userScore[@"parent"]= [PFUser currentUser];
        [userScore setObject:[NSNumber numberWithInt:100] forKey:@"points"];
        [userScore saveInBackground];
    
        userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
        userAvatar.backgroundColor = [UIColor blueColor];
        userAvatar.layer.cornerRadius = 25;

        
        avUserCallsign = [[UILabel alloc]initWithFrame:CGRectMake(75, 30, 100, 40)];
        avUserCallsign.text = [PFUser currentUser][@"callSign"];
        [self.view addSubview:userAvatar];
        [self.view addSubview:avUserCallsign];
    
    }
    return self;
}




-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    lastLocation = currentLocation;
    NSLog(@"lastLocation : %@", lastLocation);

    CLLocation * location = [locations lastObject];
    
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
        region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1.0, 1.0));
        
        //Set custom subtitles like callSign+mine
        //annotation.title = @"Title";
        //annotation.subtitle = @"Subtitle";
        
        
        
        region.span = MKCoordinateSpanMake(0.1, 0.1);
  
        
        
        [myMapView setRegion:region animated:YES];
        
        ////////MAP//////////
        
        currentLocation = location;
        NSLog(@"currentLocation : %@", currentLocation);
    
    
    
//        CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
//        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
//         
//    
//         {
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
//            userLocation[@"Latitude"] = currentLocation.coordinate.latitude;
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

                 for (PFObject * userLookForMine in mineObjects)
                 {
                     PFUser * parent = userLookForMine[@"parent"];
                     
                     if ((parent != [PFUser currentUser][@"parent"])) //&& (parent != nil))
                 
                     {
//                         Need to increment mine setters score by +10
//                         [parent incrementKey:@"points" byAmount:[NSNumber numberWithInt:10]];
//                         [parent saveInBackground];
                         
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
//                NSLog(@"Searching for enemies returning objects %@",objects);
            
                //Need to cycle through objects array, and query parse for the objectId's that it retruns in order to get, the call sign, username, avatar
                
                 
                // create enemy id mutable array
                NSMutableArray * enemyIdArray = [@[]mutableCopy];
                
                for (PFObject * enemyLocation in objects)
                {
                    
                    
                    
                    /////////trying to get distance//////////
//                    CLLocation * enemyGeo = enemyLocation[@"CurrentLocation"];
//                    
//                    enemyDist = [location distanceFromLocation:enemyGeo];
                    
                    
                    
                    //////////Trying to add enemy to map//////////
//                    CLLocation * enemyMapLocation = enemyLocation[@"CurrentLocation"];
//                    MAPAnnotation * enemyAnnotation = [[MAPAnnotation alloc]initWithCoordinate:enemyMapLocation.coordinate];
//                    [myMapView addAnnotation:enemyAnnotation];
//                    pinView.pinColor = enemyAnnotation;
                    
                    
                    
                    
                    
                    PFUser * parent = enemyLocation[@"parent"];
//                    NSLog(@"THIS IS enemyLocation %@",enemyLocation);
                    // if parent.objectId is in enemy array "continue"
                    if ([enemyIdArray containsObject:parent.objectId])
                    {
                        
//                        NSLog(@"THIS IS enemyIdArray %@",enemyIdArray);
//                        
//                        NSLog(@"THIS IS THE parent.objectID %@",parent.objectId);
                        
                        
                        
                        continue;
                    
                    
                    }
                    // add parent.objectId to enemy id array
                    [enemyIdArray addObject:parent.objectId];
                    
                    
                    [parent fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        
                        PFUser * callSign = (PFUser *)object[@"callSign"];
                    
                        NSLog(@"THIS IS callSign %@", callSign);
                        
//                        NSLog(@"THIS IS object %@", object);

                        
                        
                        
                        //Adding object to singleton mutable array of enemies in proximity
//                        if (![[GTASingleton sharedData].enemiesInProximity containsObject:object]) [[GTASingleton     sharedData].enemiesInProximity addObject:object];
                    
                     
                        //Adding object to singleton mutable array of enemies in proximity

                        [[GTASingleton sharedData].enemiesInProximity addObject:object];
                        
                        
                        // trigger tableview to reload
                        [gtaTVC.tableView reloadData];
                        
                        NSLog(@"THIS IS THE singleton %@",[GTASingleton sharedData].enemiesInProximity);
                        
                        //this will search the enemiseInProximity array for duplicates
                        //                        if (![[GTASingleton sharedData].enemiesInProximity containsObject:object])
                        //                            [[GTASingleton sharedData].enemiesInProximity addObject:object];
                    
                    }];
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
        
//         }];
    }
}


-(void)tripMine
{
//    mineWasTrippedTest = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 10, 10)];
//    mineWasTrippedTest.backgroundColor = [UIColor redColor];
//    [self.view addSubview:mineWasTrippedTest];
    
    [userScore incrementKey:@"points" byAmount:[NSNumber numberWithInt:-10]];
    [userScore saveInBackground];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width,245)];

    myMapView.delegate = self;
    myMapView.layer.cornerRadius = 0;

    [self.view addSubview:myMapView];
    
    
    headerFrame = [[UIImageView alloc]initWithFrame:CGRectMake(200, 25, 100, 30)];
    [headerFrame setImage: [UIImage imageNamed:@"battletag"]];
    [self.view addSubview:headerFrame];
    
    
    
    
    
    
    
    
//    targets = [[UITableView alloc]initWithFrame:CGRectMake(-3, ((SCREEN_HEIGHT / 5)*3), self.view.frame.size.width, (SCREEN_HEIGHT/2))];
//    [targets addSubview:gtaTVC.view];
    
    //gtaTVC = [[GTATableViewController alloc]initWithNibName:nil bundle:nil];
//    gtaTVC = [[GTATableViewController alloc]initWithStyle:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ((SCREEN_HEIGHT / 3)*2))];
    //[self.view addSubview:gtaTVC];
    
    // Do any additional setup after loading the view.
}


-(void)moveToAttackMode:(GTATableViewController *)VC passThroughDictionary:(NSDictionary *)profile

{
    
    
//    UIView * attackPanel;
//    attackPanel.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        attackPanel.frame = CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height / 2);
//    }];
//    
//    [self.view addSubview:attackPanel];
    
    
    
    
    
    _attackModeActive = YES;

    if (_attackModeActive == YES)
    {
        region.span = MKCoordinateSpanMake(0.01, 0.01);
        [myMapView setRegion:region animated:YES];

    }

    [UIView animateWithDuration:0.2 animations:^{
        myMapView.frame = CGRectMake(10, 60, self.view.frame.size.width - 20, 200);
        myMapView.layer.cornerRadius = 110;
        
        
        
        
        
    }];
    
    NSLog(@"press");
    
    [UITableView animateWithDuration:0.2 animations:^{
        gtaTVC.view.frame = CGRectMake(0, self.view.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    
    mineLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, self.view.frame.size.height - 110, 70, 20)];
    mineLabel.text = [NSString stringWithFormat:@"mines"];
    mineLabel.textColor = [UIColor blackColor];
    mineLabel.font = [UIFont systemFontOfSize:20];
    
    mines = [[UIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - 85, 40, 40)];
    mines.backgroundColor = [UIColor grayColor];
    [mines addTarget:self action:@selector(toggleMines) forControlEvents:UIControlEventTouchUpInside];

    
    rocketLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, self.view.frame.size.height - 110, 70, 20)];
    rocketLabel.text = [NSString stringWithFormat:@"rockets"];
    rocketLabel.textColor = [UIColor blackColor];
    rocketLabel.font = [UIFont systemFontOfSize:20];
    
    rockets = [[UIButton alloc]initWithFrame:CGRectMake(250, self.view.frame.size.height - 85, 40, 40)];
    rockets.backgroundColor = [UIColor blackColor];
    [rockets addTarget:self action:@selector(toggleRockets) forControlEvents:UIControlEventTouchUpInside];
    
    avEnemyCallsign = [[UILabel alloc]initWithFrame:CGRectMake(60, 275, 100, 40)];
    avEnemyCallsign.text = [profile objectForKey: @"callSign"];
    avEnemyCallsign.textColor = [UIColor greenColor];
    avEnemyCallsign.font = [UIFont systemFontOfSize:24];
    
    avEnemyDistance = [[UILabel alloc]initWithFrame:CGRectMake(205, 300, 85, 20)];
    //avEnemyDistance.text = [NSString stringWithFormat:@"%f", enemyDist];
    avEnemyDistance.textColor = [UIColor purpleColor];
    avEnemyDistance.font = [UIFont systemFontOfSize:18];

    //presentation purposes only//
    avEnemyDistance.text = [NSString stringWithFormat:@"200 ft"];

    
    avEnemyLocation = [[UILabel alloc] initWithFrame:CGRectMake(175, 275, 130, 20)];
    avEnemyLocation.textColor = [UIColor purpleColor];
    avEnemyLocation.font = [UIFont systemFontOfSize:20];
    avEnemyLocation.text = [NSString stringWithFormat:@"Union Square"];
    
    avEnemyScore = [[UILabel alloc] initWithFrame:CGRectMake(125, 395, 85, 30)];
    avEnemyScore.textColor = [UIColor orangeColor];
    avEnemyScore.font = [UIFont systemFontOfSize:24];
    avEnemyScore.text = [NSString stringWithFormat:@"255 pts"];
    
    
    enemyAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 225, 60, 60)];
    enemyAvatar.backgroundColor = [UIColor redColor];
    enemyAvatar.layer.cornerRadius = 30;
    
    
    //avEnemyScore

    
    [UIImageView animateWithDuration:0.2 animations:^{
        userAvatar.frame = CGRectMake(10, 30, 60, 60);
        userAvatar.layer.cornerRadius = 30;
    }];
//
//    [UILabel animateWithDuration:0.2 animations:^{
//        avUserCallsign.frame = CGRectMake(40, 250, 100, 40);
//    }];
    
    
    avUserScore = [[UILabel alloc]initWithFrame:CGRectMake(40, 320, 70, 20)];
    //avUserScore.text

    backButton = [[UIButton alloc]initWithFrame:CGRectMake (5, (self.view.frame.size.height - 35), self.view.frame.size.width - 10, 30)];
    backButton.layer.cornerRadius = 5;
    backButton.backgroundColor = [UIColor blackColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToScanMode) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:avEnemyCallsign];
    [self.view addSubview:avEnemyUsername];
    [self.view addSubview:avEnemyDistance];
    [self.view addSubview:avEnemyScore];
    [self.view addSubview:enemyAvatar];
    [self.view addSubview:avEnemyLocation];

    [self.view addSubview:avUserUsername];
    [self.view addSubview:avUserScore];

    
    [self.view addSubview:mineLabel];
    [self.view addSubview:rocketLabel];
    [self.view addSubview:mines];
    [self.view addSubview:rockets];
    [self.view addSubview:backButton];

}


-(void)backToScanMode
{
    
    _attackModeActive = NO;
    
    
    
    if (_attackModeActive == NO)
    {
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        [myMapView setRegion:region animated:YES];
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        myMapView.frame = CGRectMake(0, 60, self.view.frame.size.width,245);
        myMapView.layer.cornerRadius = 0;

    
    }];
    
    [UITableView animateWithDuration:0.2 animations:^{
        gtaTVC.view.frame = CGRectMake(0, 300, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 320);
    }];
    
    [UIImageView animateWithDuration:0.2 animations:^{
        userAvatar.frame = CGRectMake(10, 30, 50, 50);
        userAvatar.layer.cornerRadius = 25;

    }];
//
//    [UILabel animateWithDuration:0.2 animations:^{
//        avUserCallsign.frame = CGRectMake(65, 30, 100, 40);
//    }];

    _minesToggled = NO;
    _rocketsToggled = NO;
    
    [avEnemyCallsign removeFromSuperview];
    [avEnemyDistance removeFromSuperview];
    [avEnemyScore removeFromSuperview];
    [enemyAvatar removeFromSuperview];
    [avEnemyLocation removeFromSuperview];
    
    [avUserUsername removeFromSuperview];
    [avUserScore removeFromSuperview];
    
    [mineLabel removeFromSuperview];
    [rocketLabel removeFromSuperview];
    [mines removeFromSuperview];
    [rockets removeFromSuperview];
    [backButton removeFromSuperview];
}


//////TURNING MINES AND ROCKETS ON AND OFF//////////////
-(void)toggleMines
{
    if((_minesToggled == NO) && (_rocketsToggled == NO))
    {
        _minesToggled = YES;
        mines.backgroundColor = [UIColor greenColor];
        
    }
    else
    {
        _minesToggled = NO;
        mines.backgroundColor = [UIColor grayColor];    }
}


-(void)toggleRockets
{
    if((_rocketsToggled == NO) && (_minesToggled == NO))
    {
        _rocketsToggled = YES;
        rockets.backgroundColor = [UIColor redColor];
    
    }
    else
    {
        
        _rocketsToggled = NO;
        rockets.backgroundColor = [UIColor blackColor];    }
}




//////////touch to drop mine////////////////
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    
    
    
    MAPAnnotation * annotationObj = (MAPAnnotation *)annotation;
    
    MKAnnotationView * annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    ///trying to get avatars for mines and user to display differently below
//
//    MKAnnotationView * mineAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:mineAnnotation reuseIdentifier:@"mineAnnotationView"];
    
    //initializing and defining the info within the annotationView (the info) ***always need an annotation, don't necessarily always need an annotationView***
    
    annotationView.image = annotationObj.marker;
    
    ////use below to return to red pin///////
    if (annotationView == nil)
    {
        //initializing and defining the info within the annotationView (the info) ***always need an annotation, don't necessarily always need an annotationView***
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    
    
    } else {
        //reset annotationView property to new annotation location
        annotationView.annotation = annotation;
    }
    
    //Make your pin a specific picture
    //annotationView.image = [UIImage imageNamed:@"angry_5.png"];
    
    annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"THIS IS view.annotation.title %@", view.annotation.title);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CLLocation * pinLocation;
    
    if (_minesToggled == YES) {
        
    for (UITouch * touch in touches)
    {
        CGPoint location = [touch locationInView:myMapView];
        
        CLLocationCoordinate2D coordinate = [myMapView convertPoint:location toCoordinateFromView:myMapView];
        
        //moves map to center on current location
        [myMapView setCenterCoordinate:coordinate animated:YES];
        
        //sets marker to current location
        
        MAPAnnotation * mineAnnotation = [[MAPAnnotation alloc]initWithCoordinate:coordinate];
        
//        mineAnnotation.marker = [UIImage imageNamed:@"mine"];
        
//        MKAnnotationView * mineAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:mineAnnotation reuseIdentifier:nil];
//        mineAnnotationView.image = [UIImage imageNamed:@"mine.png"];

        //adds marker to mapView
        [myMapView addAnnotation:mineAnnotation];
        
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
                      for (PFObject * mineLookForUser in objects)
                      {
                          PFUser * parent = mineLookForUser[@"parent"];
                          
                          if ((parent != [PFUser currentUser][@"parent"])) //&& (parent != nil))
                              
                          {
                              [self tripMine];
                              
                          }
                      else
                      {
                          return;
                      }
                      }
                      
                      NSLog(@"Mine searching for user : %@",objects);
                  }];
                 
             //}
         }];
        
    }

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
