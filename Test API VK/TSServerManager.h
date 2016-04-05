//
//  TSServerManager.h
//  Test API VK
//
//  Created by Mac on 27.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSUser.h"
#import "TSSubscriptions.h"

@interface TSServerManager : NSObject

+ (TSServerManager *) sharedManager;

- (void) getFreindsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray *freinds)) success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) getDetailWithUserID:(NSString *) userID
                   onSuccess:(void(^)(TSUser *user)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure ;

- (void) getSubscriptionsFriend:(NSString *) userID
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSMutableArray *subscription)) success
                      onFailure:(void(^)(NSError *error, NSInteger sttusCode)) failure;

- (void) getFollowersFriend:(NSString *) userID
                      count:(NSInteger) count
                  onSuccess:(void(^)(NSMutableArray *followers)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) getWallFriend:(NSString *) userID
        withWallOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSMutableArray *listOfRecords)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
