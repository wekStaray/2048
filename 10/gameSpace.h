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
@property(nonatomic,assign) int score;
@end

NS_ASSUME_NONNULL_END
