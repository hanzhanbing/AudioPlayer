//
//  MusicModel.h
//  AudioPlayer
//
//  Created by 15240496 on 16/4/1.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, strong) NSNumber *music_id; // 歌曲id
@property (nonatomic, strong) NSString *name; // 歌曲名
@property (nonatomic, strong) NSString *icon; // 图片
@property (nonatomic, strong) NSString *fileName; // 歌曲地址
@property (nonatomic, strong) NSString *singer; // 歌手
@property (nonatomic, strong) NSString *introduce; // 介绍

@end
