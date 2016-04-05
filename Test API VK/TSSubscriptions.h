//
//  TSSubscriptions.h
//  Test API VK
//
//  Created by Mac on 01.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSubscriptions : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *subscriptionsID;

- (id) initWithServerResponseSubscriptions:(NSDictionary *) responseObject;

@end
