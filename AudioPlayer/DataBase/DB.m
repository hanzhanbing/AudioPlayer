//
//  DB.m
//  AudioPlayer
//
//  Created by 15240496 on 2017/12/23.
//  Copyright © 2017年 15240496. All rights reserved.
//

#import "DB.h"

@implementation DB

// 创建数据库指针
static sqlite3 *db = nil;

// 打开数据库
+ (sqlite3 *)open {
    
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便
    
    // 懒加载
    if (db != nil) {
        return db;
    }
    
    // 获取Documents路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 生成数据库文件在沙盒中的路径
    NSString *sqlPath = [docPath stringByAppendingPathComponent:@"music.sqlite"];
    NSLog(@"文件路径：%@",sqlPath);
    
    // 打开数据库需要使用一下函数
    // 第一个参数是数据库的路径（因为需要的是C语言的字符串，而不是NSString所以必须进行转换）
    // 第二个参数是指向指针的指针
    sqlite3_open([sqlPath UTF8String], &db);
    
    return db;
}

// 关闭数据库
+ (void)close {
    
    // 关闭数据库
    sqlite3_close(db);
    
    // 将数据库的指针置空
    db = nil;
    
}

// 创建音乐表
+ (void)createMusicTable {
    
    // 将建表的sql语句放入NSString对象中
    NSString *sql = @"create table if not exists Music (music_id int primary key, name text, icon text, fileName text not null, singer text, introduce text)";
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    // 执行sql语句
    int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
    
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    } else {
        NSLog(@"建表失败");
    }
    
    // 关闭数据库
    [DB close];
    
}

// 获取表中保存的所有音乐
+ (NSMutableArray *)allMusics {
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    // 创建一个语句对象
    sqlite3_stmt *stmt = nil;
    
    // 声明数组对象
    NSMutableArray *mArr = nil;
    
    // 此函数的作用是生成一个语句对象，此时sql语句并没有执行，创建的语句对象，保存了关联的数据库，执行的sql语句，sql语句的长度等信息
    int result = sqlite3_prepare_v2(db, "select * from Music", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        
        // 为数组开辟空间
        mArr = [NSMutableArray arrayWithCapacity:0];
        
        // SQLite_ROW仅用于查询语句，sqlite3_step()函数执行后的结果如果是SQLite_ROW，说明结果集里面还有数据，会自动跳到下一条结果，如果已经是最后一条数据，再次执行sqlite3_step()，会返回SQLite_DONE，结束整个查询
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取记录中的字段值
            // 第一个参数是语句对象，第二个参数是字段的下标，从0开始
            int music_id = sqlite3_column_int(stmt, 0);
            // 将获取到的C语言字符串转换成OC字符串
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *icon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *fileName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            NSString *singer = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *introduce = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            
            MusicModel *model = [[MusicModel alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",music_id] forKey:@"music_id"];
            [dic setObject:name forKey:@"name"];
            [dic setObject:icon forKey:@"icon"];
            [dic setObject:fileName forKey:@"fileName"];
            [dic setObject:singer forKey:@"singer"];
            [dic setObject:introduce forKey:@"introduce"];
            [model setValuesForKeysWithDictionary:dic];
            // 添加音乐信息到数组中
            [mArr addObject:model];
        }
    }
    
    // 关闭数据库
    sqlite3_finalize(stmt);
    
    return mArr;
    
}

// 根据指定的ID，查找相对应的音乐
+ (MusicModel *)findMusicByID:(int)ID {
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    // 创建一个语句对象
    sqlite3_stmt *stmt = nil;
    
    MusicModel *model = nil;
    
    // 生成语句对象
    int result = sqlite3_prepare_v2(db, "select * from Music where music_id = ?", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        // 如果查询语句或者其他sql语句有条件，在准备语句对象的函数内部，sql语句中用？来代替条件，那么在执行语句之前，一定要绑定
        // 1代表sql语句中的第一个问号，问号的下标是从1开始的
        sqlite3_bind_int(stmt, 1, ID);
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
        
            // 获取记录中的字段值
            // 第一个参数是语句对象，第二个参数是字段的下标，从0开始
            int music_id = sqlite3_column_int(stmt, 0);
            // 将获取到的C语言字符串转换成OC字符串
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *icon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *fileName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            NSString *singer = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *introduce = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            
            MusicModel *model = [[MusicModel alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",music_id] forKey:@"music_id"];
            [dic setObject:name forKey:@"name"];
            [dic setObject:icon forKey:@"icon"];
            [dic setObject:fileName forKey:@"fileName"];
            [dic setObject:singer forKey:@"singer"];
            [dic setObject:introduce forKey:@"introduce"];
            [model setValuesForKeysWithDictionary:dic];
        }
    }
    
    // 先释放语句对象
    sqlite3_finalize(stmt);
    return model;
    
}

// 插入一条音乐记录
+ (void)insertMusicWithID:(int)music_id name:(NSString *)name icon:(NSString *)icon fileName:(NSString *)fileName singer:(NSString *)singer introduce:(NSString *)introduce {
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "insert into Music values(?,?,?,?,?,?)", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        // 绑定
        sqlite3_bind_int(stmt, 1, music_id);
        sqlite3_bind_text(stmt, 2, [name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [icon UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [fileName UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [singer UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 6, [introduce UTF8String], -1, nil);
        
        // 插入与查询不一样，执行结果没有返回值
        sqlite3_step(stmt);
        
    }
    
    // 释放语句对象
    sqlite3_finalize(stmt);
    
}

// 更新指定ID下的音乐信息
+ (void)updateMusicName:(NSString *)name  icon:(NSString *)icon fileName:(NSString *)fileName singer:(NSString *)singer introduce:(NSString *)introduce forID:(int)music_id {
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "update Music set name = ?, icon = ?, fileName = ?, singer = ?, introduce = ? where music_id = ?", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [icon UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [fileName UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [singer UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [introduce UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 6, music_id);
        
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
}

// 根据指定ID删除音乐
+ (void)deleteMusicByID:(int)music_id {
    
    // 打开数据库
    sqlite3 *db = [DB open];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "delete from Music where music_id = ?", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, music_id);
        sqlite3_step(stmt);
    }
    
    sqlite3_finalize(stmt);
}

@end
