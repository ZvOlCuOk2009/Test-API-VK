//
//  TSServerManager.m
//  Test API VK
//
//  Created by Mac on 27.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSServerManager.h"
#import "AFNetworking.h"
#import "TSWall.h"


@interface TSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation TSServerManager


+(TSServerManager *)sharedManager {
    
    static TSServerManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

#pragma mark - Methods API

-(void) getFreindsWithOffset:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray *friends)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"155346819",   @"user_id",
                           @"name",        @"order",
                           @(count),       @"count",
                           @(offset),      @"offset",
                           @"photo_100",   @"fields",
                           @"nom",         @"name_case",
                           nil];

    [self.sessionManager GET:@"friends.get"
                  parameters:param
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *dictsArray = [responseObject objectForKey:@"response"];
        NSMutableArray *objectArray = [NSMutableArray array];
        for (NSDictionary *dict in dictsArray) {
            TSUser *user = [[TSUser alloc] initWithServerResponse:dict];
            [objectArray addObject:user];
        }
        if (success) {
            success(objectArray);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
         if (failure) {
             failure(error, operation.response.expectedContentLength);
         }
    }];
}

-(void) getDetailWithUserID:(NSString *) userID
                  onSuccess:(void(^)(TSUser *user)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                           userID,   @"user_id",
                           @"online, bdate, photo_400_orig", @"fields",
                           @"nom",   @"name_case",
                           nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *userInfo = [responseObject objectForKey:@"response"];
                         for (NSDictionary *dict in userInfo) {
                             TSUser *user = [[TSUser alloc] initWithServerResponse:dict];
                             if (success) {
                                 success(user);
                                 NSLog(@"objectArray count = %ld", [userInfo count]);
                             }
                         }
                         NSLog(@"JSON: %@", responseObject); 
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error, task.response.expectedContentLength);
                             NSLog(@"failure: %@", error);
                         }
                     }];
}

- (void) getSubscriptionsFriend:(NSString *) userID
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSMutableArray *subscription)) success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,             @"user_id",
                            @"photo_100,name", @"fields",
                            @(1),               @"extended",
                            @(0),               @"offset",
                            @(count),           @"count",
                            nil];
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         NSArray *dictSubscriptions = [responseObject objectForKey:@"response"];
                         NSMutableArray *subscriptionsPhoto = [NSMutableArray array];
                         for (NSDictionary *dict in dictSubscriptions) {
                             NSString *name = [dict objectForKey:@"name"];
                             id photo = [dict objectForKey:@"photo_100"];
                             NSDictionary *result =
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              photo, @"photo_100", nil];
                             [subscriptionsPhoto addObject:result];
                             if (success) {
                                 success(subscriptionsPhoto);
                             }
                         }
                         NSLog(@"JSON: %@", responseObject);
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         if (failure) {
                             failure(error, operation.response.expectedContentLength);
                         }
        
    }];
}

- (void) getFollowersFriend:(NSString *) userID
                      count:(NSInteger) count
                  onSuccess:(void(^)(NSMutableArray *followers)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,       @"user_id",
                            @"photo_100", @"fields",
                            @(0),         @"offset",
                            @(count),     @"count",
                            nil];
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         NSLog(@"JSON: %@", responseObject);
                         NSMutableArray *dictFollowers = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray *followersPhoto = [NSMutableArray array];
                         for (NSDictionary *dict in dictFollowers) {
                             NSString *firstName = [dict objectForKey:@"first_name"];
                             NSString *lastName = [dict objectForKey:@"last_name"];
                             id photo = [dict objectForKey:@"photo_100"];
                             NSString *initalised = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                             NSDictionary *resault = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      initalised, @"initalised",
                                                      photo,      @"photo_100", nil];
                             [followersPhoto addObject:resault];
                             }
                         if (success) {
                             success(followersPhoto);
                         }
                     }
            failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
                if (failure) {
                    failure(error, operation.response.expectedContentLength);
                }
    }];
}

- (void) getWallFriend:(NSString *) userID
        withWallOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSMutableArray *listOfRecords)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,           @"owner_id",
                            @(offset),        @"offset",
                            @(count),         @"count",
                            @(0),             @"extended",
                            @"owner",         @"filter",
                            @"photo_50,name", @"fields", nil];
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         NSMutableArray *dictListOfRecords = [responseObject objectForKey:@"response"];
                         NSMutableArray *wallArray = [NSMutableArray array];
                         if ([dictListOfRecords count] <= 1) {
                             NSDictionary *dict = [NSDictionary dictionaryWithObject:@"error" forKey:@"wallError"];
                             TSWall *wall = [[TSWall alloc] initWithDictionary:dict];
                             [wallArray addObject:wall];
                             
                         } else {
                             for (NSDictionary *dict in dictListOfRecords) {
                                 
                                 if (![dict isEqual:[dictListOfRecords firstObject]]) {
                                     TSWall *postInfo = [[TSWall alloc] initWithDictionary:dict];
                                     [wallArray addObject:postInfo];
                                 }
                             }
                         }
                         
                         if (success) {
                             success(wallArray);
                         }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error, operation.response.expectedContentLength);
        }
    }];
}

@end
