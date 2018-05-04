//
//  RotatingView.h
//  AudioPlayer
//
//  Created by 15240496 on 16/4/12.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingView : UIView

@property (nonatomic, strong) UIImageView *imageView;

- (void)setRotatingViewLayoutWithFrame:(CGRect)frame;

// 添加动画
- (void)addAnimation;
// 停止
-(void)pauseLayer;
// 恢复
-(void)resumeLayer;
// 移除动画
- (void)removeAnimation;

@end
