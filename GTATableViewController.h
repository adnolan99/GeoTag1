//
//  GTATableViewController.h
//  GeoTag
//
//  Created by Austin Nolan on 5/23/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTATableViewControllerDelegate;


@interface GTATableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic)id<GTATableViewControllerDelegate> delegate;



@end
@protocol GTATableViewControllerDelegate <NSObject>



-(void)moveToAttackMode:(GTATableViewController *)VC passThroughDictionary:(NSDictionary *)profile;


@end