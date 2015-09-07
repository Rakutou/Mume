//
//  User.m
//  Mume
//
//  Created by coderyi on 15/9/7.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)sharedUser {
    static id sharedUser = nil;
    if (!sharedUser) {
        sharedUser = [[self alloc] init];
        [(User *)sharedUser load];
    }
    return sharedUser;
}

-(void) save{
    NSUserDefaults * userDefaults= [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.email forKey:@"email"];
    [userDefaults setObject:self.password forKey:@"password"];
    [userDefaults setBool:self.isLogin forKey:@"isLogin"];
    [userDefaults setObject:self.user_id forKey:@"user_id"];
    [userDefaults setObject:self.expire forKey:@"expire"];
    [userDefaults setObject:self.token forKey:@"token"];
    [userDefaults setObject:self.user_name forKey:@"user_name"];
    [userDefaults setObject:self.channel_id forKey:@"channel_id"];
}

-(void) load{
    NSUserDefaults * userDefaults= [NSUserDefaults standardUserDefaults];
    
    self.email = [userDefaults objectForKey:@"email"];
    self.password = [userDefaults objectForKey:@"password"];
    self.isLogin = [userDefaults boolForKey:@"isLogin"];
    self.user_id = [userDefaults objectForKey:@"user_id"];
    self.expire = [userDefaults objectForKey:@"expire"];
    self.token = [userDefaults objectForKey:@"token"];
    self.user_name = [userDefaults objectForKey:@"user_name"];
    self.channel_id = [userDefaults objectForKey:@"channel_id"];
}


@end
