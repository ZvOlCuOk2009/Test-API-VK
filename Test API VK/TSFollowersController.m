//
//  TSFollowersController.m
//  Test API VK
//
//  Created by Mac on 01.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSFollowersController.h"
#import "TSServerManager.h"
#import "UIImageView+AFNetworking.h"

@interface TSFollowersController ()

@property (strong , nonatomic) NSMutableArray *followersArray;

@end

@implementation TSFollowersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followersArray = [NSMutableArray array];
//    NSString *count = self.user.followersCount;
    [self getFollowersFromServer:155346819]; //берем количество фолловеров, здесь должно быть ID юзера

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API

- (void) getFollowersFromServer:(NSInteger) count {
    
    [[TSServerManager sharedManager] getFollowersFriend:self.user.userID
                                                  count:count
                                              onSuccess:^(NSMutableArray *followers) {
                                                  self.followersArray = followers;
                                                  [self.tableView reloadData];
                                                  NSLog(@"followers count = %ld", [followers count]);
                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Failed to load subscribers!!!");
                                              }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([self.followersArray count] != 0) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.followersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *followerInfo = [self.followersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[followerInfo objectForKey:@"initalised"];
    NSString *urlString = (NSString *)[followerInfo objectForKey:@"photo_100"];
    NSURL *follImageURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:follImageURL];
    cell.imageView.image = nil;
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakCell.imageView.image = image;
                                       [weakCell layoutSubviews];
                                       weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.width / 2;
                                       weakCell.imageView.clipsToBounds = YES;
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"FAILED TO LOAD THE IMAGE FOLLOWERS");
                                   }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
}
@end
