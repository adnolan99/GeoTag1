//
//  GTATableViewCell.m
//  GeoTag
//
//  Created by Austin Nolan on 5/27/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTATableViewCell.h"

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
        
        
        
        displayUserAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 275, 40, 40)];
        displayUserAvatar.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:displayUserAvatar];
        
        
        displayUserName = [[UILabel alloc] initWithFrame:CGRectMake(80, 285, 220, 40)];
        displayUserName.textColor = [UIColor blackColor];
        displayUserName.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayUserName];
        
        displayCallSign = [[UILabel alloc] initWithFrame:CGRectMake(80, 285, 220, 40)];
        displayCallSign.textColor = [UIColor blackColor];
        displayCallSign.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayCallSign];
        
        displayDistance = [[UILabel alloc] initWithFrame:CGRectMake(80, 285, 220, 40)];
        displayDistance.textColor = [UIColor blackColor];
        displayDistance.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:displayDistance];
        
        
        
        
        
        
        
        // Initialization code
    }
    return self;
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
