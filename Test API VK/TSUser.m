//
//  TSUser.m
//  Test API VK
//
//  Created by Mac on 27.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSUser.h"

@implementation TSUser

-(id)initWithServerResponse:(NSDictionary *) responseObject;

{
    self = [super init];
    if (self) {
        self.userID = [responseObject objectForKey:@"uid"];
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.bdate = [responseObject objectForKey:@"bdate"];
        NSString *urlString = [responseObject objectForKey:@"photo_100"];
        if (urlString) {
            self.photo100 = [NSURL URLWithString:urlString];
        }
        NSString *photo50 = [responseObject objectForKey:@"photo_50"];
        NSString *photo400 = [responseObject objectForKey:@"photo_400_orig"];
        self.photo50 = [NSURL URLWithString:photo50];
        self.photo400 = [NSURL URLWithString:photo400];
        self.online = [[responseObject objectForKey:@"online"] boolValue];
        self.followersCount = [responseObject objectForKey:@"followers_count"];
    }
    return self;
}

@end