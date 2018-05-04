//
//  DB.h
//  AudioPlayer
//
//  Created by 15240496 on 2017/12/23.
//  Copyright © 2017年 15240496. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

@interface DB : NSObject

// 打开数据库
+ (sqlite3 *)open;

// 关闭数据库
+ (void)close;

// 创建音乐表
+ (void)createMusicTable;

// 获取表中保存的所有音乐
+ (NSMutableArray *)allMusics;

// 根据指定的ID，查找相对应的音乐
+ (MusicModel *)findMusicByID:(int)ID;

// 插入一条音乐记录
+ (void)insertMusicWithID:(int)music_id name:(NSString *)name icon:(NSString *)icon fileName:(NSString *)fileName singer:(NSString *)singer introduce:(NSString *)introduce;

// 更新指定ID下的音乐信息
+ (void)updateMusicName:(NSString *)name  icon:(NSString *)icon fileName:(NSString *)fileName singer:(NSString *)singer introduce:(NSString *)introduce forID:(int)music_id;

// 根据指定ID删除音乐
+ (void)deleteMusicByID:(int)music_id;

@end
