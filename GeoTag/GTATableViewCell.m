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
        
        
        
        displayUserAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        displayUserAvatar.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:displayUserAvatar];
        

        displayUserName = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 50, 20)];
        displayUserName.textColor = [UIColor blackColor];
        displayUserName.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayUserName];
        
        displayCallSign = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 50, 20)];
        displayCallSign.textColor = [UIColor greenColor];
        displayCallSign.backgroundColor = [UIColor blueColor];
        displayCallSign.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayCallSign];

        
    
        displayDistance = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 50, 20)];
        displayDistance.textColor = [UIColor blackColor];
        displayDistance.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayDistance];
        
        
        
        
        
        
        
        // Initialization code
    }
    return self;
}



-(void)setProfile: (PFObject *)profile
{
    _profile = profile;
    
    
    displayCallSign.text = [profile objectForKey:@"callSign"];
    displayUserName.text = [profile objectForKey:@"username"];

    displayDistance.text = [profile objectForKey:@"userName"];

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
