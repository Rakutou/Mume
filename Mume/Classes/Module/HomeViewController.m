//
//  ViewController.m
//  Mume
//
//  Created by coderyi on 15/9/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "HomeViewController.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import "Track.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#import "MenuViewController.h"

@interface HomeViewController ()<MenuViewControllerDelegate>{
    NSMutableArray *tracks;
    DOUAudioStreamer *streamer;
    Track *prevTrack;
    Track *currentTrack;
    NSMutableArray *channels;
    NSString *channel_id;
    User *user;

}

@end

@implementation HomeViewController
#pragma mark - Lifecycle

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [self initAllValue];

    
    
}

#pragma mark - UIResponder methods
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPause];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self next];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Actions
- (void)playingAction:(id)sender {
    [self playOrPause];
}

- (void)nextAction{
    if (self.nextBt.alpha<0.9) {
        return;
    }
    self.love.alpha=0.7;
    self.trash.alpha=0.7;
    self.nextBt.alpha=0.7;
    [self next];
    
    //seed skip message
    if (prevTrack != nil){
        NSString *skipURL=@"http://douban.fm/j/app/radio/people";
        NSMutableDictionary *skipParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"s",@"type",user.channel_id,@"channel",nil];
        [skipParameters setObject:prevTrack.sid forKey:@"sid"];
        if (user.isLogin) {
            [skipParameters setObject:user.user_id forKey:@"user_id"];
            [skipParameters setObject:user.expire forKey:@"expire"];
            [skipParameters setObject:user.token forKey:@"token"];
        }
        AFHTTPSessionManager *skipManager=[AFHTTPSessionManager manager];
        [skipManager GET:skipURL parameters:skipParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"skip is success");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error%@",error);
            self.love.alpha=0.7;
            self.trash.alpha=0.7;
            self.nextBt.alpha=0.7;
        }];
    }
    
}


- (void)finishAction:(id)sender {
    
    [self next];
    
    //seed end message
    if (prevTrack != nil){
        NSString *endURL=@"http://douban.fm/j/app/radio/people";
        NSMutableDictionary *endParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"s",@"type",user.channel_id,@"channel",nil];
        [endParameters setObject:prevTrack.sid forKey:@"sid"];
        if (user.isLogin) {
            [endParameters setObject:user.user_id forKey:@"user_id"];
            [endParameters setObject:user.expire forKey:@"expire"];
            [endParameters setObject:user.token forKey:@"token"];
        }
        AFHTTPSessionManager *endManager=[AFHTTPSessionManager manager];
        [endManager GET:endURL parameters:endParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"end is success");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error%@",error);
        }];
    }
}
- (void)loveAction:(id)sender {
    if (self.love.alpha<0.9) {
        return;
    }
    self.love.alpha=0.7;
    self.trash.alpha=0.7;
    self.nextBt.alpha=0.7;
    
    if (currentTrack != nil){
        NSString *loveURL=@"http://douban.fm/j/app/radio/people";
        NSMutableDictionary *loveParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"r",@"type",user.channel_id,@"channel",nil];
        [loveParameters setObject:currentTrack.sid forKey:@"sid"];
        if (user.isLogin) {
            [loveParameters setObject:user.user_id forKey:@"user_id"];
            [loveParameters setObject:user.expire forKey:@"expire"];
            [loveParameters setObject:user.token forKey:@"token"];
        }
        AFHTTPSessionManager *loveManager=[AFHTTPSessionManager manager];
        [loveManager GET:loveURL parameters:loveParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            self.love.selected = YES;
            NSLog(@"Love is success");
            self.love.alpha=1.0;
            self.trash.alpha=1.0;
            self.nextBt.alpha=1.0;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error%@",error);
            self.love.alpha=1.0;
            self.trash.alpha=1.0;
            self.nextBt.alpha=1.0;
        }];
    }
}

- (void)trashAction:(id)sender {
    if (self.trash.alpha<0.9) {
        return;
    }
    
    
    self.love.alpha=0.7;
    self.trash.alpha=0.7;
    self.nextBt.alpha=0.7;
    if (currentTrack != nil) {
        NSString *trashURL=@"http://douban.fm/j/app/radio/people";
        NSMutableDictionary *trashParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"b",@"type",user.channel_id,@"channel",nil];
        [trashParameters setObject:currentTrack.sid forKey:@"sid"];
        if (user.isLogin) {
            [trashParameters setObject:user.user_id forKey:@"user_id"];
            [trashParameters setObject:user.expire forKey:@"expire"];
            [trashParameters setObject:user.token forKey:@"token"];
        }
        AFHTTPSessionManager *trashManager=[AFHTTPSessionManager manager];
        [trashManager GET:trashURL parameters:trashParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [self next];
            NSLog(@"trash is success");
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error%@",error);
            
            self.love.alpha=1.0;
            self.trash.alpha=1.0;
            self.nextBt.alpha=1.0;
        }];
    }
}




#pragma mark - Private

-(void)initAllValue{
    //初始化所有值
    self.view.backgroundColor=[UIColor whiteColor];
    self.love=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.love];
    self.love.frame=CGRectMake((ScreenWidth-250)/2, 410, 32, 32);
    [self.love setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    [self.love setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
    
    [self.love addTarget:self action:@selector(loveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.trash=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.trash];
    self.trash.frame=CGRectMake((ScreenWidth-250)/2+(250-32)/2, 410, 32, 32);
    [self.trash setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.trash addTarget:self action:@selector(trashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.trash setImage:[UIImage imageNamed:@"trash_can_normal"] forState:UIControlStateNormal];
    
    
    
    self.nextBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.nextBt];
    self.nextBt.frame=CGRectMake((ScreenWidth-250)/2+218, 410, 32, 32);
    [self.nextBt setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
    [self.nextBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.nextBt addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    channel_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_id"];
    
    tracks=[NSMutableArray array];
    
    
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2, 75, 250, 250)];
    [self.view addSubview:self.imageView];

    
    //歌曲图片以圆形呈现
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 125;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.audioVisualizerView=[[DOUAudioVisualizer alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2, 140, 250, 250)];
    [self.view addSubview:self.audioVisualizerView];
    self.progress=[[DACircularProgressView alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2, 75, 250, 250)];
    [self.view addSubview:self.progress];
    
    self.progress.trackTintColor = [UIColor colorWithRed:0.884f green:0.867f blue:0.839f alpha:0.3f];
    self.progress.progressTintColor = YiRed;
    self.progress.thicknessRatio = 0.03f;
    self.progress.roundedCorners = YES;
    //设置音乐进度条
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    
    self.songTitle=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-300)/2, 35, 300, 30)];
    [self.view addSubview:self.songTitle];
    self.songTitle.textAlignment=NSTextAlignmentCenter;
    
    self.songTitle.text = @"";
    [self.songTitle setNumberOfLines:0];
    self.songTitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    self.playing=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.playing];
    self.playing.frame=CGRectMake((ScreenWidth-50)/2, 75+(250-50)/2, 50, 50);
    [self.playing setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playing addTarget:self action:@selector(playingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playing.hidden = YES;
    self.playing.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.playing.layer.masksToBounds = YES;
    self.playing.layer.cornerRadius = 20;
    
    
    
    //歌曲图片增加单击事件
    UITapGestureRecognizer *singTapHidden=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [self.progress addGestureRecognizer:singTapHidden];
    
    user = [User sharedUser];
    if (user.channel_id.length == 0) {
        user.channel_id = @"0";
    }
    //重新登陆
    if (user.email.length != 0 && user.password.length != 0) {
        [self loginWithName:user.email password:user.password];
    }
    
    //频道列表
    [self getChannels];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 处理打断消息
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:    @selector(handleInterruption:)
                                                 name:        AVAudioSessionInterruptionNotification
                                               object:      [AVAudioSession sharedInstance]];
    
    //自动播放
    [self next];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
-(void)progressChange{
    if (streamer.duration == 0.0) {
        [self.progress setProgress:0.0f animated:NO];
    }else{
        [self.progress setProgress:[streamer currentTime] / [streamer duration] animated:YES];
    }
    [self configNowPlayingInfoCenter];
}


- (void)next{
    self.love.selected = NO;
    
    prevTrack = currentTrack;
    currentTrack = nil;
    
    if(![self playNextTrack])
    {
        // 没有歌了，加载新的吧
        [self getTracks];
    }
}
- (void)playOrPause{
    if ([streamer status] == DOUAudioStreamerPaused || [streamer status] == DOUAudioStreamerIdle) {
        [streamer play];
        self.playing.hidden = YES;
    }else{
        [streamer pause];
        self.playing.hidden = NO;
    }
}


-(BOOL)playNextTrack{
    [self removeObserverForStreamer];
    if (tracks.count == 0) {
        return NO;
    }
    currentTrack =[tracks firstObject];
    [tracks removeObject:currentTrack];
    streamer=[DOUAudioStreamer streamerWithAudioFile:currentTrack];
    [streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self progressChange];
    NSString *title=[NSString stringWithFormat:@"%@ - %@",currentTrack.title,currentTrack.artist];
    [self.songTitle setText:title];
    self.love.selected = currentTrack.isLike;
    
    [self.imageView setImage:[currentTrack picture]];
    self.playing.hidden = YES;
    [streamer play];
    
    [self configNowPlayingInfoCenter];
    
    NSLog(@"play %@-%@",currentTrack.title,currentTrack.artist);
    
    self.trash.alpha=1.0;
    self.love.alpha=1.0;
    self.nextBt.alpha=1.0;
    return YES;
}

-(void)removeObserverForStreamer{
    if (streamer != nil) {
        [streamer removeObserver:self forKeyPath:@"status"];
        streamer=nil;
    }
}


- (void) configNowPlayingInfoCenter{
    // 更新锁屏信息
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
        
        if(currentTrack != nil){
            MPMediaItemArtwork *albumArt = [ [MPMediaItemArtwork alloc] initWithImage: [currentTrack picture] ];
            
            [ songInfo setObject: currentTrack.title forKey:MPMediaItemPropertyTitle ];
            [ songInfo setObject: currentTrack.artist forKey:MPMediaItemPropertyArtist ];
            [ songInfo setObject: currentTrack.albumTitle forKey:MPMediaItemPropertyAlbumTitle ];
            [ songInfo setObject: albumArt forKey:MPMediaItemPropertyArtwork ];
            
            [songInfo setObject:[NSNumber numberWithDouble:[streamer duration]] forKey:MPMediaItemPropertyPlaybackDuration];
            [songInfo setObject:[NSNumber numberWithDouble:[streamer currentTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
            
            [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
        }
    }
}


- (void)handleInterruption:(id)sender {
    //停止播放的事件
    [self playOrPause];
}



#pragma mark - Tracks methods

-(void)getTracks{
    NSString *url=@"http://douban.fm/j/app/radio/people";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

    
    NSMutableDictionary *songParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name", @"100",@"version",@"n",@"type",user.channel_id,@"channel",nil];
    
    if (prevTrack !=  nil) {
        [songParameters setObject:@"p" forKey:@"type"];
        [songParameters setObject:prevTrack.sid forKey:@"sid"];
    }
    if (user.isLogin) {
        [songParameters setObject:user.user_id forKey:@"user_id"];
        [songParameters setObject:user.expire forKey:@"expire"];
        [songParameters setObject:user.token forKey:@"token"];
    }
    NSLog(@"get new tracks , current channel is %@",[songParameters objectForKey:@"channel"]);
    [manager GET:url parameters:songParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseSongs=[responseObject objectForKey:@"song"];
        
        for (NSDictionary *song in responseSongs) {
            //依次赋值给track
            Track *track=[[Track alloc] init];
            track.artist=[song objectForKey:@"artist"];
            track.title=[song objectForKey:@"title"];
            track.albumTitle=[song objectForKey:@"albumtitle"];
            track.sid=[song objectForKey:@"sid"];
            track.url=[NSURL URLWithString:[song objectForKey:@"url"]];
            track.picture=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[song objectForKey:@"picture"]]]];
            track.isLike=[[song objectForKey:@"like"] boolValue];
            
            [tracks addObject:track];
        }
        
        NSLog(@"get %d tracks",tracks.count);
        
        //如果当前没歌，自动播放
        if (currentTrack == nil) {
            [self playNextTrack];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[getTracks]Network connect failure:error--->%@",error);
    }];
}
#pragma mark - Channels method
-(void)getChannels{
    NSString *url=@"http://douban.fm/j/app/radio/channels";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    if (channels != nil) {
        channels = nil;
    }
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        

        NSDictionary *responseChannels=[responseObject objectForKey:@"channels"];
        channels=[NSMutableArray array];
        for (NSDictionary *dicChannels in responseChannels) {
            //依次赋值给channel
            Channel *channel=[[Channel alloc] init];
            channel.name=[dicChannels objectForKey:@"name"];
            NSInteger channel_id = [[dicChannels objectForKey:@"channel_id"] intValue];
            channel.channel_id = [NSString stringWithFormat:@"%d",channel_id];
            [channels addObject:channel];
        }
        
        UIViewController *leftViewController = self.sidePanelController.leftPanel;
        if ([leftViewController isKindOfClass:[MenuViewController class]]){
            MenuViewController *chvc=(MenuViewController *)leftViewController;
            chvc.channels=channels;
            [chvc.tableView reloadData];
            chvc.delegate=self;
        }
        
        NSLog(@"get Channels success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[getChannels]Network connect failure:error--->%@",error);
    }];
}
#pragma mark - Login method
-(void)loginWithName:(NSString *)name password:(NSString *)password{
    
    NSString *url=@"http://www.douban.com/j/app/login";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *loginParameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"radio_desktop_win",@"app_name",
                                          @"100",@"version",name,@"email",password,@"password",nil];
    
    [manager POST:url parameters:loginParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginMess=(NSDictionary *)responseObject;
        
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
            
            [self.navigationController popViewControllerAnimated:YES];
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
        NSLog(@"[getLogin]Network connect failure:error--->%@",error);
    }];
}

#pragma mark - MenuViewControllerDelegate method
-(void)MenuViewControllerDidSelect:(MenuViewController *)controller didChannel:(Channel *)selectChannel{
    NSLog(@"channel_id--->name:%@--->%@",selectChannel.channel_id,selectChannel.name);
    if (user.channel_id != selectChannel.channel_id) {
        user.channel_id = selectChannel.channel_id;
        
        [user save];
        
        prevTrack = nil;
        currentTrack = nil;
        
        [tracks removeAllObjects];
        
        // 自动播放
        [self next];
    }
    
    [self.sidePanelController showCenterPanelAnimated:YES];
}

#pragma mark - KVO method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"] ) {
        if ([streamer status] == DOUAudioStreamerFinished){
            [self performSelector:@selector(finishAction:)
                         onThread:[NSThread mainThread]
                       withObject:nil
                    waitUntilDone:NO];
        }
    }
}
@end
