//
//  JKObject.h
//  SimpleTest
//
//  Created by Jack's MacBook Air on 16/7/12.
//  Copyright © 2016年 Jack's MacBook Air. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKObject : NSObject

typedef void (^TestBlock)(NSString *pram);

@property(nonatomic,copy) void (^callback)(NSString *str);

-(void)handleUrl:(NSString *)urlStr completion:(void (^)(NSData *))completionHandler;

@end
