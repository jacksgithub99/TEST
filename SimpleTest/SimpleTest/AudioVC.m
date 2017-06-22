//
//  AudioVC.m
//  SimpleTest
//
//  Created by Jack's MacBook Air on 16/7/17.
//  Copyright © 2016年 Jack's MacBook Air. All rights reserved.
//

#import "AudioVC.h"

#import <AVFoundation/AVFoundation.h>

@interface AudioVC ()<AVAudioPlayerDelegate>
{
    //the rain must fall  http://home.9ku.com/mp3down.php?id=8849
    //with an orchid  http://home.9ku.com/mp3down.php?id=425261
    //santorini http://home.9ku.com/mp3down.php?id=8844
    
    AVAudioPlayer *_player;
    
    NSTimer *_progressTimer;
    
    AVPlayer *_avPlayer;
    AVPlayerLayer *_playerLayer;
}

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation AudioVC


- (IBAction)preBtn:(id)sender {
    
}


- (IBAction)playBtn:(id)sender {
    
    
    if (_player != nil) {
        NSBlockOperation *opration = [NSBlockOperation blockOperationWithBlock:^{
            
            UIButton *btn = (UIButton *)sender;
            
            if ([btn.titleLabel.text isEqualToString:@"|>"]) {
                [btn setTitle:@"||" forState:UIControlStateNormal];//暂停
                
                [_player play];
                
                [self setUpTimer];
            }else
            {
                [btn setTitle:@"|>" forState:UIControlStateNormal];//播放
                
                [_player pause];
                
                [self cancelTimer];
            }
            
        }];
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [queue addOperation:opration];
    }
}

-(void)setUpTimer
{
    if (_progressTimer != nil && ![_progressTimer isValid]) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
    if (_progressTimer == nil) {
        NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(progressUpdate)];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:self];
        [invocation setSelector:@selector(progressUpdate)];
        
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.f invocation:invocation repeats:YES];
        [_progressTimer fire];
    }
}

-(void)cancelTimer
{
    if (_progressTimer != nil) {
        if ([_progressTimer isValid]) {
            [_progressTimer invalidate];
        }
        _progressTimer = nil;
    }
}


- (IBAction)nextBtn:(id)sender {
    
}


-(void)loadView
{
    [super loadView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *localUrlStr = [[NSBundle mainBundle] pathForResource:@"withAnOrchid" ofType:@"mp3"];
    
    NSURL *localUrl = [NSURL fileURLWithPath:localUrlStr];
    
//  AVAudioPlayer只能播放本地音频  NSURL *netUrl = [NSURL URLWithString:@"http://mp3downb.111ttt.com/2016/zw/07/CWH/%E6%B3%A1%E6%B2%ABdj_%E9%82%93%E7%B4%AB%E6%A3%8B(McYy_Remix_%E5%8F%A6%E4%B8%80%E7%89%88_%E5%9B%BD%E8%AF%AD_%E5%A5%B3)www.111Ttt.com.m4a"];
    
    NSError *err;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:localUrl error:&err];
    _player.delegate = self;
    [_player prepareToPlay];
    
    _progressView.progress = 0.f;
    
    
    [self setTitle:@"hello"];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
}

-(void)goback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)progressUpdate
{
    if (_player != nil && _player.isPlaying) {
        float progress = _player.currentTime/_player.duration;
        
        [_progressView setProgress:progress animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_playBtn setTitle:@"|>" forState:UIControlStateNormal];//播放
        
        [_progressView setProgress:0.f animated:NO];
        
        _player.currentTime = 0.f;
        
        [_player play];
        
    });
}




@end
