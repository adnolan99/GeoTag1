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
    
    UIImageView * displayEnemyAvatar;
    UILabel * dispEnemyUserName;
    UILabel * dispEnemyCallSign;
    UILabel * dispEnemyDistance;
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        displayEnemyAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 50, 50)];
        displayEnemyAvatar.backgroundColor = [UIColor redColor];
        displayEnemyAvatar.layer.cornerRadius = 25;
        [self.contentView addSubview:displayEnemyAvatar];
        

        dispEnemyUserName = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 50, 20)];
        dispEnemyUserName.textColor = [UIColor blueColor];
        dispEnemyUserName.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:dispEnemyUserName];
        
        dispEnemyCallSign = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 50, 20)];
        dispEnemyCallSign.textColor = [UIColor greenColor];
        dispEnemyCallSign.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:dispEnemyCallSign];

        
    
        dispEnemyDistance = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 85, 20)];
        dispEnemyDistance.textColor = [UIColor purpleColor];
        dispEnemyDistance.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:dispEnemyDistance];
        
        
        
        
        
        
        
        // Initialization code
    }
    return self;
}



-(void)setProfile: (PFObject *)profile
{
    _profile = profile;
    
    
    dispEnemyCallSign.text = [profile objectForKey:@"callSign"];
    dispEnemyUserName.text = [profile objectForKey:@"username"];
    //dispEnemyDistance.text = [profile objectForKey:@"NEED TO TO GET DISTANCE"];

    
    
    
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
