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
#import <UIKit/UIKit.h>
#import "GameOverView.h"

@interface ViewController ()
@property(nonatomic,strong) gameSpace *game;
@property(nonatomic,strong) UILabel *scoreBoard,*score;
@property(nonatomic,strong) GameOverView *over;
@end

@implementation ViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)gameStart{
    [self.game startGame];
    
    if([self.over superview])
        [self.over removeFromSuperview];
    
    self.scoreBoard.text = @"0";
}

- (UILabel *)scoreBoard {
    if(!_scoreBoard) {
        _scoreBoard = [UILabel new];
        [_scoreBoard setFont:[UIFont systemFontOfSize:40]];
        _scoreBoard.text = @"0";
    }
    return _scoreBoard;
}

-(void)test{
    
}
-(gameSpace*)game{
    if(!_game){
        _game = [gameSpace new];
        
        __weak UILabel *board = self.scoreBoard;
        
        _game.score = ^(int score){
            int num = [board.text intValue];
            board.text = [NSString stringWithFormat: @"%d",num + score];
        };
        
        [self.view addSubview:self.game];
        
        CGFloat temp = self.view.frame.size.width - 20;
        
        [_game mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 100, 10));
            make.height.width.mas_equalTo(temp);
        }];
        [self.view layoutIfNeeded];
        [_game layout:4];
        [self gameStart];
    }
    
    
    return _game;
}
- (GameOverView *)over{
    if(!_over){
        _over = [GameOverView new];
        
    }
    return _over;
}

- (void)check{
    if(![self.game GameOver]){
        
        if([_over superview] == self.view) return;
        
        [self.view addSubview:_over];
        [_over mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.view) ;
        }];
        [self.view layoutIfNeeded];
        [_over initial];
        
        [self.over.restartButton addTarget:self
                                    action:@selector(gameStart)
                          forControlEvents:UIControlEventTouchUpInside
         ];
    }
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
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
    
    self.score = [UILabel new];
    
    self.score.text = @"Score: ";
    
    [self.score setFont:[UIFont systemFontOfSize:40]];
    [self.view addSubview:self.score];
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.equalTo(self.view).insets(UIEdgeInsetsMake(100, 10, 0, 0));
        make.width.mas_equalTo(self.view.frame.size.width/3);
        make.height.mas_equalTo(btn);
    }];
    
    [self.view addSubview:self.scoreBoard];
    [self.scoreBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.score.mas_right);
        make.width.mas_equalTo(self.view.frame.size.width/3*2);
        make.height.mas_equalTo(btn);
    }];
}


@end
