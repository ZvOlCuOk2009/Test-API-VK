//
//  TSWallUserController.m
//  Test API VK
//
//  Created by Mac on 03.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSWallUserController.h"
#import "TSServerManager.h"
#import "TSWallTableViewCell.h"

@interface TSWallUserController ()

@property (strong, nonatomic) NSMutableArray *listOfPosts;

@end

const static NSInteger wallPostCount = 10;
const static NSInteger constPostImageWidth = 320;

@implementation TSWallUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWallFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getWallFromServer {
    
    [[TSServerManager sharedManager] getWallFriend:self.user.userID
                withWallOffset:[self.listOfPosts count]
                         count:wallPostCount
                     onSuccess:^(NSMutableArray *listOfRecords) {
                         self.listOfPosts = listOfRecords;
                         NSInteger object = 0;
                         
                         for (TSWall *wallPost in self.listOfPosts) {
                             NSData *dataPostImage = [[NSData alloc]initWithContentsOfURL:wallPost.postImageURL];
                             wallPost.postImage = [UIImage imageWithData:dataPostImage];
                             
                             if (self.user.photo50 != nil) {
                                 NSData *dataUserImage = [[NSData alloc]initWithContentsOfURL:self.user.photo50];
                                 wallPost.userImage = [UIImage imageWithData:dataUserImage];
                                 object++;
                             }
                         }
                         [self.tableView reloadData];
                     }
                     onFailure:^(NSError *error, NSInteger statusCode) {
                         NSLog(@"FAILED TO LOAD USER WALL");
                     }];
}

- (NSString *) removeHTMLTags:(NSString *) string {
    
    NSRange range;
    
    if (string != nil) {
        while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            string = [string stringByReplacingCharactersInRange:range withString:@" "];
        }
    }
    return string;
}

- (UIImage *) imageWithImage:(UIImage *) image convertToSize:(CGSize) size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    
    if ([self.listOfPosts count] == 1) {
        title = @"Стена закрыта";
    }
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.listOfPosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierWall = @"wallCell";
    static NSString *identifierError = @"errorCell";
    
    TSWall *wallPosts = [self.listOfPosts objectAtIndex:indexPath.row];
    
    if ([wallPosts.wallError isEqualToString:@"error"]) {
        UITableViewCell *errorCell = [tableView dequeueReusableCellWithIdentifier:identifierError];
        
        if (!errorCell) {
            errorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierError];
        }
        errorCell.textLabel.text = @"Доступ к записям ограничен";
        return errorCell;
        
    } else {
        TSWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierWall];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        cell.postDataLabel.text = wallPosts.postsData;
        cell.postTextLabel.text = [self removeHTMLTags:wallPosts.postsText];
        NSLog(@"%@", cell.postTextLabel.text);
        cell.postTitleLabel.text = [self removeHTMLTags:wallPosts.postTitle];
        NSLog(@"%@", cell.postTitleLabel.text);
        cell.commentsCountLabel.text = wallPosts.commentsCount;
        cell.repostsCountLabel.text = wallPosts.repostsCount;
        cell.likesCountLabel.text = wallPosts.likesCount;
        cell.avatarImage.image = wallPosts.userImage;
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.width / 2;
        cell.avatarImage.layer.masksToBounds = YES;
        
        if (wallPosts.postImage != nil) {
            CGFloat proportionalHeight = (float)(wallPosts.postImage.size.height / wallPosts.postImage.size.width) * constPostImageWidth;
            cell.postImage.image = [self imageWithImage:wallPosts.postImage convertToSize:CGSizeMake(constPostImageWidth, proportionalHeight)];
            
        } else {
            cell.postImage.image = wallPosts.postImage;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
