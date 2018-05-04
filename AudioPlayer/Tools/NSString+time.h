//
//  NSString+time.h
//  AudioPlayer
//
//  Created by 15240496 on 16/4/12.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (time)

// 播放器_时间转换
+ (NSString *)convertTime:(CGFloat)second;

@end
