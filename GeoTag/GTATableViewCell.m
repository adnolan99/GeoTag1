//
//  GTATableViewCell.m
//  GeoTag
//
//  Created by Austin Nolan on 5/27/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTATableViewCell.h"

#import "GTASingleton.h"



@implementation GTATableViewCell
{
    
    UIImageView * displayUserAvatar;
    UILabel * displayUserName;
    UILabel * displayCallSign;
    UILabel * displayDistance;
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        displayUserAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
        displayUserAvatar.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:displayUserAvatar];
        
//        
//        displayUserName = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 10, 10)];
//        displayUserName.textColor = [UIColor blackColor];
//        displayUserName.font = [UIFont systemFontOfSize:20];
//        [self.contentView addSubview:displayUserName];
        
        displayCallSign = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 50, 20)];
        displayCallSign.textColor = [UIColor greenColor];
        displayCallSign.backgroundColor = [UIColor blueColor];
        displayCallSign.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayCallSign];

        
    
//        displayDistance = [[UILabel alloc] initWithFrame:CGRectMake(80, 285, 220, 40)];
//        displayDistance.textColor = [UIColor blackColor];
//        displayDistance.font = [UIFont systemFontOfSize:20];
//        [self.contentView addSubview:displayDistance];
        
        
        
        
        
        
        
        // Initialization code
    }
    return self;
}

//
-(void)setProfile: (PFObject *)enemyProfile
{
    _enemyProfile = enemyProfile;
    
    displayCallSign.text = [enemyProfile objectForKey:@"callSign"];

    NSLog(@"TVCell log %@", displayCallSign.text);
    
    
    
    //NSDictionary * enemy = [GTASingleton sharedData].enemiesInProximity[index];
    //displayCallSign.text = enemy[@"callSign"];

}





- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
