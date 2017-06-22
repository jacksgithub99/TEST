//
//  NSObject+runtimeProperty.m
//  SimpleTest
//
//  Created by Jack's MacBook Air on 17/6/20.
//  Copyright © 2017年 Jack's MacBook Air. All rights reserved.
//

#import "NSObject+runtimeProperty.h"
#import <objc/runtime.h>


@implementation NSObject (runtimeProperty)

//@dynamic name;

static char nameKey;

- (void)setName:(NSString *)name {
    
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
    
    id object = objc_getAssociatedObject(self, &nameKey);
    
    return (NSString *)object;
}

@end
