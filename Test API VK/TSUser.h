//
//  TSUser.h
//  Test API VK
//
//  Created by Mac on 27.02.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

//Класс создан для удобства обработки JSON из GET запроса

@interface TSUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *bdate;
@property (strong, nonatomic) NSURL *photo50;
@property (strong, nonatomic) NSURL *photo100;
@property (strong, nonatomic) NSURL *photo400;
@property (assign, nonatomic) BOOL online;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *followersCount;

-(id)initWithServerResponse:(NSDictionary *) resposeObject;

@end
