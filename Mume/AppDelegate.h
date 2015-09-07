//
//  AppDelegate.h
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;
@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic) HomeViewController *mumeViewController;
//@property(strong,nonatomic) LoginViewController *loginViewController;
@property(strong,nonatomic) UINavigationController *loginViewController;

@end

