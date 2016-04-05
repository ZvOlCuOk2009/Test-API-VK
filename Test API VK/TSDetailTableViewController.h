//
//  TSDetailTableViewController.h
//  Test API VK
//
//  Created by Mac on 28.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSUser.h"

@interface TSDetailTableViewController : UITableViewController

@property (strong, nonatomic) TSUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bdataLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

- (IBAction)actionSubscript:(id)sender;
- (IBAction)actionFollow:(id)sender;
- (IBAction)actionWall:(id)sender;

@end
