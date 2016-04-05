//
//  TSWallUserController.h
//  Test API VK
//
//  Created by Mac on 03.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSUser.h"
#import "TSWall.h"

@interface TSWallUserController : UITableViewController

@property (strong, nonatomic) TSUser *user;
@property (strong, nonatomic) TSWall *wall;

@end
