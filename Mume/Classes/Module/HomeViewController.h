//
//  ViewController.h
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DACircularProgressView.h"
#import "DOUAudioVisualizer.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel *songTitle;
@property (strong, nonatomic)  DACircularProgressView *progress;
@property (strong, nonatomic)  DOUAudioVisualizer *audioVisualizerView;

@property (strong, nonatomic)  UIButton *playing;
@property (strong, nonatomic)  UIButton *love;
@property (strong, nonatomic)  UIButton *trash;
@property (strong, nonatomic)  UIButton *nextBt;
@end

