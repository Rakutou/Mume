//
//  ChannelsViewController.h
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"
@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void)MenuViewControllerDidSelect:(MenuViewController *)controller didChannel:(Channel *)selectChannel;

@end
@interface MenuViewController : UITableViewController

@property (nonatomic,strong) id <MenuViewControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *channels;
@end
