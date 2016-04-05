//
//  TSWallTableViewCell.h
//  Test API VK
//
//  Created by Mac on 03.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSWallTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *commentsImage;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repostsImage;
@property (weak, nonatomic) IBOutlet UILabel *repostsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likesImage;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;

@end
