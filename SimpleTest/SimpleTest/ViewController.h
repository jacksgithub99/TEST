//
//  ViewController.h
//  SimpleTest
//
//  Created by Jack's MacBook Air on 15/11/20.
//  Copyright © 2015年 Jack's MacBook Air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(copy,nonatomic)  void (^theBlock)(BOOL finished);

@end

