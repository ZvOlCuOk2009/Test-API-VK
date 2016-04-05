//
//  TSSubscriptionsController.m
//  Test API VK
//
//  Created by Mac on 01.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSubscriptionsController.h"
#import "TSServerManager.h"
#import "TSSubscriptions.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface TSSubscriptionsController ()

@property (strong, nonatomic) NSMutableArray *subscriptionsArray;

@end

@implementation TSSubscriptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscriptionsArray = [NSMutableArray array];
    [self getSubscriptionFromServer:100];
    NSLog(@"self.user.userID = %@", self.user.userID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getSubscriptionFromServer:(NSInteger) count {
    
    [[TSServerManager sharedManager]
     getSubscriptionsFriend:self.user.userID
                      count:count
                  onSuccess:^(NSMutableArray *subscription) {
          self.subscriptionsArray = subscription;
                      [self.tableView reloadData];
                      NSLog(@"subscription count = %ld", [subscription count]);
      }
      onFailure:^(NSError *error, NSInteger statusCode) {
          NSLog(@"Failed to load subscribers!!!");
      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([self.subscriptionsArray count] != 0) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.subscriptionsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *subscriptInfo = [self.subscriptionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[subscriptInfo objectForKey:@"name"];
    NSString *urlString = (NSString *)[subscriptInfo objectForKey:@"photo_100"];
    NSURL *subImageURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:subImageURL];
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
                                       NSLog(@"FAILED TO LOAD THE IMAGE SUBSCRIPTIONS");
                                   }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
}

@end
