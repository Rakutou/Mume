//
//  User.h
//  Mume
//
//  Created by coderyi on 15/9/7.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;

@property (nonatomic) BOOL isLogin;

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * expire;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * user_name;

@property (nonatomic, retain) NSString * channel_id;

+ (User *)sharedUser;

-(void) save;
-(void) load;
@end
