//
//  Track.h
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"

@interface Track : NSObject<DOUAudioFile>

@property (nonatomic,strong) NSString *artist;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *albumTitle;
@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIImage *picture;
@property (nonatomic) BOOL isLike;


@end
