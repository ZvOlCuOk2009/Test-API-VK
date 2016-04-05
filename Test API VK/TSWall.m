//
//  TSWall.m
//  Test API VK
//
//  Created by Mac on 03.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSWall.h"

@implementation TSWall

- (instancetype) initWithDictionary:(NSDictionary *) dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary count] != 1) {
            self.commentsCount = [[[dictionary objectForKey:@"comments"] objectForKey:@"count"] stringValue];
            self.likesCount = [[[dictionary objectForKey:@"likes"] objectForKey:@"count"] stringValue];
            self.repostsCount = [[[dictionary objectForKey:@"reposts"] objectForKey:@"count"] stringValue];
            
            NSDateFormatter *dataformater = [[NSDateFormatter alloc] init];
            [dataformater setDateFormat:@"dd.MM.yyyy"];
            NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"date"] floatValue]];
            
            self.postsData = [dataformater stringFromDate:dateTime];
            self.postsText = (NSString *)[dictionary objectForKey:@"text"];
            self.attachMentType = [[dictionary objectForKey:@"attachment"] objectForKey:@"type"];
            
            if ([self.attachMentType isEqualToString:@"video"]) {
                self.attachmentData = [[dictionary objectForKey:@"attachment"] objectForKey:@"video"];
                self.postTitle = [self.attachmentData objectForKey:@"title"];
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"image_big"]];
                
            } else if ([self.attachMentType isEqualToString:@"link"]) {
                self.attachmentData = [[dictionary objectForKey:@"attachment"] objectForKey:@"link"];
                self.postTitle = [self.attachmentData objectForKey:@"title"];
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"image_src"]];
                
                if (self.postImageURL == nil) {
                    self.postsText = (NSString *)[self.attachmentData objectForKey:@"url"];
                }
            } else if ([self.attachMentType isEqualToString:@"photo"]) {
                self.attachmentData = [[dictionary objectForKey:@"attachment"] objectForKey:@"photo"];
                self.postTitle = [self.attachmentData objectForKey:@"text"];
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"src_big"]];
                
            } else if ([self.attachMentType isEqualToString:@"audio"]) {
                self.postImageURL = nil;
                self.attachmentData = [[dictionary objectForKey:@"attachment"] objectForKey:@"audio"];
                NSString *artist = [self.attachmentData objectForKey:@"artist"];
                NSString *title = [self.attachmentData objectForKey:@"title"];
                self.postTitle = [NSString stringWithFormat:@"%@ - %@", artist, title];
                
            } else if ([self.attachMentType isEqualToString:@"doc"]) {
                self.attachmentData = [[dictionary objectForKey:@"attachment"] objectForKey:@"doc"];
                self.postTitle = [self.attachmentData objectForKey:@"text"];
                self.postImageURL = [NSURL URLWithString:[self.attachmentData objectForKey:@"thumb_s"]];
                
            } else {
                self.postImageURL = nil;
            }
        } else {
            self.wallError = [dictionary objectForKey:@"wallError"];
        }
    }
    return self;
}

@end
