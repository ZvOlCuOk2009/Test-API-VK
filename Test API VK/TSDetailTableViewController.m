//
//  TSDetailTableViewController.m
//  Test API VK
//
//  Created by Mac on 28.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSDetailTableViewController.h"
#import "TSServerManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "TSSubscriptionsController.h"
#import "TSFollowersController.h"
#import "TSWallUserController.h"

@interface TSDetailTableViewController ()

@property (strong, nonatomic) NSMutableArray *subscriptionsArray;
@property (strong, nonatomic) NSMutableArray *followersArray;

@end

@implementation TSDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoImageView.layer.cornerRadius = self.photoImageView.bounds.size.width / 2;
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.layer.borderWidth = 3;
    self.photoImageView.layer.borderColor = [[UIColor colorWithRed:29.0f / 255.0f green:109.f / 255.0f blue:251.f / 255.f alpha:1] CGColor];
    self.title = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    self.navigationController.navigationBar.topItem.title = @""; //убрать текст с навигейн button
    self.tableView.separatorColor = [UIColor clearColor];
    [self getFriendDetailFromServer];
    NSLog(@"self.user.userID = %@", self.user.userID);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// методы установки панели инструментов

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void) getFriendDetailFromServer {
    
    [[TSServerManager sharedManager] getDetailWithUserID:self.user.userID
       onSuccess:^(TSUser *user) {
           self.user = user;
           NSLog(@"firstName = %@ lastName = %@", user.firstName, self.user.lastName);
           [self.tableView beginUpdates];
           self.firstNameLabel.text = self.user.firstName;
           self.lastNameLabel.text = self.user.lastName;
           self.bdataLabel.text = self.user.bdate;
           NSLog(@"followers count is %@", self.user.followersCount);
           if (self.user.online == 0) {
               self.onlineLabel.text = @"Offline";
               self.onlineLabel.textColor = [UIColor grayColor];
           } else {
               self.onlineLabel.text = @"Online";
               self.onlineLabel.textColor = [UIColor greenColor];
           }
           NSURLRequest *requestPhoto400 =
           [NSURLRequest requestWithURL:self.user.photo400];
           self.photoImageView.image = nil;
           [self.photoImageView setImageWithURLRequest:requestPhoto400
                                      placeholderImage:nil
                                               success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                   self.photoImageView.image = image;
                                                   [self.photoImageView layoutSubviews];
                                               }
                                               failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                   NSLog(@"ERROR FAILURE IMAGE");
                                               }];
           [self.tableView endUpdates];
       }
       onFailure:^(NSError *error, NSInteger statusCode) {
           NSLog(@"error = %@, code = %ld",[error localizedDescription],statusCode);
       }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (IBAction)actionSubscript:(id)sender {
    
    TSSubscriptionsController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"TSSubscriptionsController"];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionFollow:(id)sender {
    
    TSFollowersController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"TSFollowersController"];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)actionWall:(id)sender {
    
    TSWallUserController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"TSWallUserController"];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
