//
//  LoginViewController.m
//  Mume
//
//  Created by coderyi on 15/9/7.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
@interface LoginViewController (){
    UITextField *usernameTF;
    UITextField *pwdTF;
    User *user;

}


@end

@implementation LoginViewController
#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"douban.com login"];


    self.navigationController.navigationBar.tintColor=YiRed;
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIImageView *titleIV=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2, 100, 40, 40)];
    [self.view addSubview:titleIV];
    titleIV.image=[UIImage imageNamed:@"github60"];
    usernameTF=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-300)/2, 150, 300, 40)];
    [self.view addSubview:usernameTF];
    usernameTF.backgroundColor=[UIColor whiteColor];
    usernameTF.textAlignment=NSTextAlignmentCenter;
    usernameTF.layer.borderWidth=0.4;
    usernameTF.layer.borderColor=YiRed.CGColor;
    usernameTF.placeholder=@"email";
    pwdTF=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-300)/2, 200, 300, 40)];
    [self.view addSubview:pwdTF];
    pwdTF.layer.borderWidth=0.4;
    pwdTF.textAlignment=NSTextAlignmentCenter;
    pwdTF.placeholder=@"password";
    pwdTF.layer.borderColor=YiRed.CGColor;
    pwdTF.backgroundColor=[UIColor whiteColor];
    pwdTF.secureTextEntry = YES;
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:but];
    but.frame=CGRectMake((ScreenWidth-200)/2, 250, 200, 40);
    [but setBackgroundColor:YiRed];
    but.titleLabel.tintColor=[UIColor whiteColor];
    [but setTitle:@"Sign in" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(loginBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    user = [User sharedUser];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)tapAction{
    if ([usernameTF isFirstResponder]) {
        [usernameTF resignFirstResponder];
    }else if ([pwdTF isFirstResponder]){
        [pwdTF resignFirstResponder];
    }
}
- (void)loginBtAction{

    if (usernameTF.text.length<1 || !usernameTF.text) {
        return;
    }
    
    if (pwdTF.text.length<1 || !pwdTF.text) {
        return;
    }
    
    
    NSString *name=usernameTF.text;
    NSString *password=pwdTF.text;
    [self showYiProgressHUD:@"logining"];

    
    NSString *url=@"http://www.douban.com/j/app/login";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *loginParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name",
                                          @"100",@"version",name,@"email",password,@"password",nil];
    
    [manager POST:url parameters:loginParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginMess=(NSDictionary *)responseObject;
        [self hideYiProgressHUD];
        
        if ( [[[loginMess objectForKey:@"r"] stringValue] isEqualToString:@"0"] ) {
            //登陆成功
            
            user.isLogin = YES;
            user.email = name;
            user.password = password;
            
            user.user_id = [loginMess objectForKey:@"user_id"];
            user.expire = [loginMess objectForKey:@"expire"];
            user.token = [loginMess objectForKey:@"token"];
            user.user_name = [loginMess objectForKey:@"user_name"];
            [user save];
            
            [self.navigationItem setTitle:user.user_name];
            
            [self.sidePanelController setCenterPanel:ApplicationDelegate.mumeViewController];
            NSLog(@"login success");
            
        }else if ( [[[loginMess objectForKey:@"r"] stringValue] isEqualToString:@"1"] ){
            //登陆失败
            user.isLogin = NO;
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登入失败" message:[NSString stringWithFormat:@"%@",[loginMess objectForKey:@"err"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"login failure");
        }

    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //网络连接失败
        user.isLogin = NO;
        [self hideYiProgressHUD];
        NSLog(@"[getLogin]Network connect failure:error--->%@",error);
    }];

    
    
}


@end
