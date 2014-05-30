//
//  GTASingleton.h
//  GeoTag
//
//  Created by Austin Nolan on 5/30/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTASingleton : NSObject

+(GTASingleton *)sharedData;



@property (nonatomic) NSMutableArray * enemiesInProximity;
@property (nonatomic) NSMutableArray * enemyProfiles;


@end
