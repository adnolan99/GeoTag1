//
//  GTAAppDelegate.m
//  GeoTag
//
//  Created by Austin Nolan on 5/23/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTAAppDelegate.h"

#import "GTAViewController.h"

#import "GTALoginViewController.h"

#import <Parse/Parse.h>

#import <Crashlytics/Crashlytics.h>

@implementation GTAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //App key
    [Parse setApplicationId:@"USbRqmBruCCYTpUrj5Hi2mVlqJ6GsSiOwoGD7XNe"
                  clientKey:@"2MkmfJf0o76TcfFBsdenVCpY2mIjThz0BNCPo2jp"];
    
    
    
    
    GTAViewController * gtaVC = [[GTAViewController alloc] initWithNibName:nil bundle:nil];
    
    
    UINavigationController * gtaNavCon = [[UINavigationController alloc]initWithRootViewController:gtaVC];
    
    PFUser * user = [PFUser currentUser];
    
    NSString * userName = user.username;
    
    //Toggle Username below for testing purposes
    userName = nil;
    
    
    
    if (userName == nil) {
        gtaNavCon = [[UINavigationController alloc]initWithRootViewController:[[GTALoginViewController alloc]initWithNibName:nil bundle:nil]];
        [gtaNavCon setNavigationBarHidden:YES];
        
    } else {
        
        gtaNavCon = [[UINavigationController alloc]initWithRootViewController:[[GTAViewController alloc]initWithNibName:nil bundle:nil]];
        [gtaNavCon setNavigationBarHidden:NO];
    }
    
    self.window.rootViewController = gtaNavCon;
    
    
    
    [Crashlytics startWithAPIKey:@"71968bbdd73dd1560953cb8384a4ae51a34f5d93"];
    //[[Crashlytics sharedInstance] crash];
    

    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
