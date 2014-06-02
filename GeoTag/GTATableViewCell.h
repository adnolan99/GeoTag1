//
//  GTATableViewCell.h
//  GeoTag
//
//  Created by Austin Nolan on 5/27/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Parse/Parse.h>
@interface GTATableViewCell : UITableViewCell


@property (nonatomic) PFObject * enemyProfile;
@property (nonatomic) NSInteger index;



@end
