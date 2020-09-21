//
//  gameSpace.h
//  10
//
//  Created by bytedance on 2020/8/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface gameSpace : UIView
-(void)layout:(int)num;
-(void)startGame;
-(BOOL)GameOver;

typedef void (^scoreAddBlock)(int score);
@property (nonatomic, strong) scoreAddBlock score;

@end

NS_ASSUME_NONNULL_END
