//
//  MusicModel.m
//  AudioPlayer
//
//  Created by 15240496 on 16/4/1.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@""]) {
        
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
