//
//  slider.h
//  10
//
//  Created by bytedance on 2020/8/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface slider : UILabel
-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w;
-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w andNum:(int)number;
@property(nonatomic,readonly)int num;
@end

NS_ASSUME_NONNULL_END
