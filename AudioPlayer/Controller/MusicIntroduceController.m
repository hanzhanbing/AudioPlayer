//
//  MusicIntroduceController.m
//  AudioPlayer
//
//  Created by 15240496 on 2017/12/26.
//  Copyright © 2017年 15240496. All rights reserved.
//

#import "MusicIntroduceController.h"

@interface MusicIntroduceController ()

@end

@implementation MusicIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //标题
    self.title = self.model.name;
    
    //介绍
    UITextView *introduceTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    introduceTV.text = self.model.introduce;
    [self.view addSubview:introduceTV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
