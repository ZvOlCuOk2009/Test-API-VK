//
//  ViewController.m
//  Test API VK
//
//  Created by Mac on 27.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "TSServerManager.h"
#import "TSUser.h"
#import "UIImageView+AFNetworking.h"
#import "TSDetailTableViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *friendsArray;
@end

@implementation ViewController

static NSInteger friendOfRequest = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsArray = [NSMutableArray array];
    [self getFriendsFromServer];
    NSLog(@"print");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void) getFriendsFromServer {
    
    [[TSServerManager sharedManager]
    getFreindsWithOffset:[self.friendsArray count]
                   count:friendOfRequest
               onSuccess:^(NSArray *freinds) {
         [self.friendsArray addObjectsFromArray:freinds]; //получили данные из ВК, запрошенные через синглтон
         NSMutableArray *newPath = [NSMutableArray array];
         for (int i = (int)[self.friendsArray count] - (int)[freinds count]; i < [self.friendsArray count]; i++) {
             [newPath addObject:[NSIndexPath indexPathForItem:i inSection:0]]; // массив из рядов создали
         };
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop]; //положили в тейблвью все строки
         [self.tableView endUpdates];
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", error, (long)statusCode);
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
        if (indexPath.row == [self.friendsArray count]) {
            cell.textLabel.text = @"LOAD MORE";
            cell.imageView.image = nil;
        } else {
            TSUser *friend = [self.friendsArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
            cell.detailTextLabel.text = @"Text";
            NSURLRequest* request = [NSURLRequest requestWithURL:friend.photo100];
            
            __weak UITableViewCell* weakCell = cell;
            cell.imageView.image = nil;
            
            [cell.imageView
             setImageWithURLRequest:request
             placeholderImage:nil
             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                 weakCell.imageView.image = image;
                 [weakCell layoutSubviews];
                 weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.width / 2.0;
                 weakCell.imageView.clipsToBounds = YES;
             }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
             }];
        }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.friendsArray count]) {
        [self getFriendsFromServer];
    } else {
    TSDetailTableViewController *detailController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"TSDetailTableViewController"];
        TSUser* clickedFriend = [self.friendsArray objectAtIndex:indexPath.row];
        detailController.user = clickedFriend;
    [self.navigationController pushViewController:detailController animated:YES];
    }
}

@end
