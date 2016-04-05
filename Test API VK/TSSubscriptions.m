//
//  TSSubscriptions.m
//  Test API VK
//
//  Created by Mac on 01.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSubscriptions.h"

@implementation TSSubscriptions


- (id) initWithServerResponseSubscriptions:(NSDictionary *) responseObject;
{
    self = [super init];
    if (self) {
        self.subscriptionsID = [responseObject objectForKey:@"user_id"];
        self.firstName = [responseObject objectForKey:@"name"];
        self.lastName = [responseObject objectForKey:@"screen_name"];
        NSString *stringURL = [responseObject objectForKey:@"photo_100"];
        if (stringURL) {
            self.imageURL = [NSURL URLWithString:stringURL];
        }
    }
    return self;
}



@end
