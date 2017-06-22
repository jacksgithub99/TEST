//
//  NoneARC.m
//  SimpleTest
//
//  Created by Jack's MacBook Air on 16/7/18.
//  Copyright © 2016年 Jack's MacBook Air. All rights reserved.
//

#import "NoneARC.h"

@implementation NoneARC

-(void)noneARCTest
{
    NSString *str1 = [[NSString alloc] initWithFormat:@"%zd",998];
    
    NSLog(@"str1 rCount = %zd",[str1 retainCount]);//-1
    
    NSString *str2 = [str1 retain];
    
    NSLog(@"str1 rCount = %zd",[str2 retainCount]);//-1
    
    
   
    
    
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"mStr"];
 
    NSLog(@"mStr rCount = %zd",[mStr retainCount]);//1
    
    NSMutableString *mStr2 = [mStr retain];
    
    NSLog(@"mStr2 rCount = %zd",[mStr2 retainCount]);//2
    
}

@end
