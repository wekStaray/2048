//
//  ViewController.m
//  10
//
//  Created by bytedance on 2020/8/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ViewController.h"
#import "gameSpace.h"
#import <Masonry/Masonry.h>



@interface ViewController ()
@property(nonatomic,strong) gameSpace *game;
@property(nonatomic,strong) UILabel *scoreBoard;
@end

@implementation ViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)gameStart{
    [self.game startGame];
    self.scoreBoard.text = @"0";
}
-(void)test{
    self.scoreBoard.text = [NSString stringWithFormat: @"%d",self.game.score];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.game = [gameSpace new];
    
    [self.view addSubview:self.game];
    
    CGFloat temp = self.view.frame.size.width-20;
    
    [self.game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 100, 10));
        make.height.width.mas_equalTo(temp);
    }];
    [self.view layoutIfNeeded];
    [self.game layout:4];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"Restart" forState:UIControlStateNormal];
    [btn setTitle:@"Restart" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.titleLabel.font = [UIFont systemFontOfSize: 24.0];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 100, 50, 100));
        make.top.mas_equalTo(self.game.mas_bottom).offset(10);
    }];
    
    [btn addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *score = [UILabel new];
    
    score.text = @"Score: ";
    
    [score setFont:[UIFont systemFontOfSize:40]];
    [self.view addSubview:score];
    [score mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.equalTo(self.view).insets(UIEdgeInsetsMake(50, 10, 0, 0));
        make.width.mas_equalTo(self.view.frame.size.width/3);
        make.height.mas_equalTo(btn);
    }];
    
    
    self.scoreBoard = [UILabel new];
    [self.scoreBoard setFont:[UIFont systemFontOfSize:40]];
    [self.view addSubview:self.scoreBoard];
    [self.scoreBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(score.mas_right);
        make.width.mas_equalTo(self.view.frame.size.width/3*2);
        make.height.mas_equalTo(btn);
    }];
    
    
    [self gameStart];

    // 创建定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(test) userInfo:nil repeats:YES];

    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    // 停止定时器
   // [timer invalidate];
}


@end
