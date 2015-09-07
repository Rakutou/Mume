
//
//  ChannelsViewController.m
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "MenuViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    self.tableView.tableHeaderView=view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"频道";

    }
    return @"Mume FM";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==1) {
        return [self.channels count];

    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;

    NSString *cellId=@"CellId1";

    cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    if (indexPath.section==1) {
        Channel *channel=[self.channels objectAtIndex:indexPath.row];
        cell.textLabel.text=channel.name;
        
        NSString *channel_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_id"];
        if ([channel.channel_id isEqualToString:channel_id])
        {
            cell.backgroundColor = [UIColor colorWithRed:0.92 green:0.26 blue:0.21 alpha:0.4];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }else{
        cell.textLabel.text=@"登录";
        if ([User sharedUser].user_name.length>0) {
            cell.textLabel.text=[User sharedUser].user_name;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        
        self.sidePanelController.centerPanel = ApplicationDelegate.mumeViewController;

        Channel *channel=[self.channels objectAtIndex:indexPath.row];
        [self.delegate MenuViewControllerDidSelect:self didChannel:channel];
        [self.tableView reloadData];
    }else{
        if ([User sharedUser].user_name.length>0) {
            return;
        }
        [self.sidePanelController showCenterPanelAnimated:YES];
        self.sidePanelController.centerPanel = ApplicationDelegate.loginViewController;

    }
    
}
@end
