//
//  GTASingleton.m
//  GeoTag
//
//  Created by Austin Nolan on 5/30/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTASingleton.h"

@interface GTASingleton ()

@end




@implementation GTASingleton
{
    
    
}





+(GTASingleton *)sharedData
{
    
    static dispatch_once_t create;
    static GTASingleton * singleton = nil;
    
    dispatch_once(&create, ^{
        singleton = [[GTASingleton alloc]init];
        
    });
    return singleton;
}

@end
