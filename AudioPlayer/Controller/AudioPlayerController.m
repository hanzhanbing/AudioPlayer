//
//  AudioPlayerController.m
//  AudioPlayer
//
//  Created by 15240496 on 16/4/1.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import "AudioPlayerController.h"
#import "NSString+time.h"
#import "MusicIntroduceController.h"

@interface AudioPlayerController (){
    AVPlayerItem *playerItem;
    id _playTimeObserver; // 播放进度观察者
    NSArray *_modelArray; // 歌曲数组
    NSArray *_randomArray; //随机数组
    NSInteger _index; // 播放标记
    BOOL isPlaying; // 播放状态
    BOOL isRemoveNot; // 是否移除通知

    MusicModel *_playingModel; // 正在播放的model
    CGFloat _totalTime; // 总时间
}
@property (weak, nonatomic) IBOutlet UISlider *paceSlider; // 进度条
@property (weak, nonatomic) IBOutlet UIButton *playButton; // 播放按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 歌名Label
@property (weak, nonatomic) IBOutlet UILabel *singerLabel; // 歌手Label
@property (weak, nonatomic) IBOutlet UILabel *playingTime; // 当前播放时间Label
@property (weak, nonatomic) IBOutlet UILabel *maxTime; // 总时间Label
@property (nonatomic, strong) AVPlayer *player;
@end

static AudioPlayerController *audioVC;
@implementation AudioPlayerController

+(AudioPlayerController *)audioPlayerController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioVC = [[AudioPlayerController alloc] init];
        audioVC.view.backgroundColor = [UIColor whiteColor];
        audioVC.player = [[AVPlayer alloc]init];
        //后台播放
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return audioVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.paceSlider setThumbImage:[UIImage imageNamed:@"SliderPoint"] forState:UIControlStateNormal];
    [self creatViews];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setRotatingViewFrame];
}

// 创建部分控件
- (void)creatViews{
    self.rotatingView = [[RotatingView alloc] init];
    self.rotatingView.imageView.image = [UIImage imageNamed:@"PlayerHeader"];
    [self.view addSubview:self.rotatingView];
}

// 设置旋转图的Frame
- (void)setRotatingViewFrame{
    CGFloat height_i4 = KScreenHeight - topHeight - downHeight;
    if (KScreenHeight < 500) {
        self.rotatingView.frame = CGRectMake(0, 0, height_i4*0.8, height_i4*0.8);
    }else{
        self.rotatingView.frame = CGRectMake(0, 0, KScreenWidth *0.8, KScreenWidth*0.8);
    }
    self.rotatingView.center = CGPointMake(KScreenWidth/2, height_i4/2 + topHeight);
    [self.rotatingView setRotatingViewLayoutWithFrame:self.rotatingView.frame];
}

// 设置旋转图片、模糊图片
- (void)setImageWith:(MusicModel *)model{
    /**
     *  添加旋转动画
     */
    [self.rotatingView addAnimation];
    
    self.underImageView.image = [UIImage imageNamed:@"PlayerFuzzyBg"];
    [self.rotatingView.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"PlayerHeader"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.underImageView.image = [image applyDarkEffect];
        }
    }];
}

- (void)initWithArray:(NSArray *)array index:(NSInteger)index{
    _index = index;
    _modelArray = array;
    _randomArray = nil;
    [self updateAudioPlayer];
}

- (void)updateAudioPlayer{
    if (isRemoveNot) {
        // 如果已经存在 移除通知、KVO，各控件设初始值
        [self removeObserverAndNotification];
        [self initialControls];
        isRemoveNot = NO;
    }
    MusicModel *model = [_modelArray objectAtIndex:_index];
    _playingModel = model;
    // 更新界面歌曲信息：歌名，歌手，图片
    [self updateUIDataWith:model];
    
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.fileName]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self monitoringPlayback:playerItem];// 监听播放状态
    [self addEndTimeNotification];
    isRemoveNot = YES;
}

// 各控件设初始值
- (void)initialControls{
    [self stop];
    self.playingTime.text = @"00:00";
    self.paceSlider.value = 0.0f;
    [self.rotatingView removeAnimation];
}

- (void)updateUIDataWith:(MusicModel *)model{
    self.titleLabel.text = model.name;
    self.singerLabel.text = model.singer;
    [self setImageWith:model];
}

#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = item.duration;// 获取视频总长度
            [self setMaxDuratuin:CMTimeGetSeconds(duration)];
            [self play];
        }else if([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            [self stop];
        }
    }
}

- (void)setMaxDuratuin:(float)duration{
    _totalTime = duration;
    self.paceSlider.maximumValue = duration;
    self.maxTime.text = [NSString convertTime:duration];
}

#pragma mark - _playTimeObserver
- (void)monitoringPlayback:(AVPlayerItem *)item {
    WS(ws);
    //这里设置每秒执行30次
    _playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        float currentPlayTime = (double)item.currentTime.value/item.currentTime.timescale;
        [ws updateVideoSlider:currentPlayTime];
    }];
}

- (void)updateVideoSlider:(float)currentTime{
    [self setLockViewWith:_playingModel currentTime:currentTime];
    self.paceSlider.value = currentTime;
    self.playingTime.text = [NSString convertTime:currentTime];
}

- (IBAction)changeSlider:(id)sender{
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(self.paceSlider.value, 1);
    [playerItem seekToTime:dragedCMTime];
}

-(void)addEndTimeNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)playbackFinished:(NSNotification *)notification{
    [self nextIndexAdd];
    [self updateAudioPlayer];
}

#pragma mark --按钮点击事件--
//分享音乐
- (IBAction)shareMusic:(id)sender {
    //分享的标题
    NSString *textToShare = _playingModel.name;
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"PlayerHeader"];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:_playingModel.fileName];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

//歌曲介绍
- (IBAction)introduceBtn:(id)sender {
    MusicIntroduceController *introduceVC = [[MusicIntroduceController alloc] init];
    introduceVC.model = _playingModel;
    [self.navigationController pushViewController:introduceVC animated:NO];
}


//页面返回
- (IBAction)disMissSelfClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

//播放/暂停按钮点击事件执行的方法
- (IBAction)playAndPauseClick:(id)sender {
    if (isPlaying) { //暂停播放
        [self stop];
    }else{ //开始播放
        [self play];
    }
}

//上一曲
- (IBAction)previousClick:(id)sender {
    [self previousIndexSub];
    [self updateAudioPlayer];
}

//下一曲
- (IBAction)nextClick:(id)sender {
    [self nextIndexAdd];
    [self updateAudioPlayer];
}

- (void)nextIndexAdd{
    _index++;
    if (_index == _modelArray.count) {
        _index = 0;
    }
}

- (void)previousIndexSub{
    _index--;
    if (_index < 0) {
        _index = _modelArray.count -1;
    }
}

//开始播放
- (void)play {
    isPlaying = YES;
    [self.player play];
    [self.playButton setImage:[UIImage imageNamed:@"OnPlay"] forState:UIControlStateNormal];
    // 开始旋转
    [self.rotatingView resumeLayer];
}

//暂停播放
- (void)stop {
    isPlaying = NO;
    [self.player pause];
    [self.playButton setImage:[UIImage imageNamed:@"OnPause"] forState:UIControlStateNormal];
    // 停止旋转
    [self.rotatingView pauseLayer];
}

#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 后台UI设置
- (void)setLockViewWith:(MusicModel*)model currentTime:(CGFloat)currentTime
{
    NSMutableDictionary *musicInfo = [NSMutableDictionary dictionary];
    // 设置Singer
    [musicInfo setObject:model.singer forKey:MPMediaItemPropertyArtist];
    // 设置歌曲名
    [musicInfo setObject:model.name forKey:MPMediaItemPropertyTitle];
    // 设置封面
    MPMediaItemArtwork *artwork;
    artwork = [[MPMediaItemArtwork alloc] initWithImage:self.rotatingView.imageView.image];
    [musicInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
    // 音乐剩余时长
    [musicInfo setObject:[NSNumber numberWithDouble:_totalTime] forKey:MPMediaItemPropertyPlaybackDuration];
    // 音乐当前播放时间
    [musicInfo setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
