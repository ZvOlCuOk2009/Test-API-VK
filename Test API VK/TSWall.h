//
//  TSWall.h
//  Test API VK
//
//  Created by Mac on 03.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSWall : NSObject

@property (strong, nonatomic) NSString *commentsCount;
@property (strong, nonatomic) NSString *likesCount;
@property (strong, nonatomic) NSString *repostsCount;
@property (strong, nonatomic) NSString *postsData;
@property (strong, nonatomic) NSString *postsText;
@property (strong, nonatomic) NSString *attachMentType;

// далее свойства, которые зависят от attachmentType, которое может быть video, photo, link, doc

@property (strong, nonatomic) NSString *postTitle;

@property (strong, nonatomic) NSDictionary* attachmentData;
@property (strong, nonatomic) NSURL* postImageURL;

@property (strong, nonatomic) UIImage* userImage;
@property (strong, nonatomic) UIImage* postImage;

// Если стена не доступна!

@property (strong, nonatomic) NSString* wallError;

- (instancetype)initWithDictionary:(NSDictionary*) dictionary;

@end
