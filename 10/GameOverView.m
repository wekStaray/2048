//
//  GameOverView.m
//  10
//
//  Created by bytedance on 2020/8/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "GameOverView.h"
#import <Masonry/Masonry.h>
@interface GameOverView()
@property(nonatomic,strong) UILabel *Gameover;

@end

@implementation GameOverView
- (UILabel *)Gameover{
    if(!_Gameover){
        _Gameover = [UILabel new];
        _Gameover.text = @"Game over";
        _Gameover.font = [UIFont systemFontOfSize:30];
        _Gameover.textAlignment = NSTextAlignmentCenter;
        _Gameover.center = self.center;
        [self addSubview: _Gameover];
        
    }
    return _Gameover;
}
- (UIButton *)restartButton{
    if(!_restartButton){
        
        _restartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_restartButton setTitle:@"Restart" forState:UIControlStateNormal];
        [_restartButton setTitle:@"Restart" forState:UIControlStateHighlighted];
        [_restartButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_restartButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _restartButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0.1 alpha:1];
        [self addSubview:_restartButton];
        
    }
    
    return _restartButton;
}

- (void) initial{
    
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    
    [self.Gameover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.mas_width).multipliedBy(0.25);
    }];
    
    [self.restartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Gameover.mas_bottom).offset(10);
        make.left.right.equalTo(self.Gameover);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.mas_width).multipliedBy(0.25);
    }];
    
}
@end
