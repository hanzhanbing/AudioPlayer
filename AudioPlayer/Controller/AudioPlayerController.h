//
//  AudioPlayerController.h
//  AudioPlayer
//
//  Created by 15240496 on 16/4/1.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicModel.h"
#import "UIImage+ImageEffects.h" // 模糊效果
#import "RotatingView.h"   // 旋转View

/**
 *  注：为适配中间旋转图片大小
 *      topHeight: 上部分控件高度
 *      downHeight: 下部分控件高度
 */
static CGFloat topHeight = 64.0+20.0; 
static CGFloat downHeight = 100.0+16.0;

@interface AudioPlayerController : UIViewController

+(AudioPlayerController *)audioPlayerController;

/**
 *  旋转View
 */
@property (strong, nonatomic) RotatingView *rotatingView;
/**
 *  背景模糊图
 */
@property (weak, nonatomic) IBOutlet UIImageView *underImageView;

/**
 *  播放器数据传入
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)initWithArray:(NSArray *)array index:(NSInteger)index;

@end
