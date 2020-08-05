//
//  slider.m
//  10
//
//  Created by bytedance on 2020/8/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "slider.h"
@interface slider()
-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w;
-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w andNum:(int)number;
@end

@implementation slider

-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w{
    
    if(self = [super initWithFrame:CGRectMake(pos.x+w/2, pos.y+w/2, 0, 0)])
    {
        int temp = arc4random()%5;
        if(!temp) _num = 4;
        else _num = 2;
        self.frame = CGRectMake(pos.x, pos.y, w, w);
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [[UIColor grayColor]CGColor];
        self.layer.masksToBounds = YES;
        self.text = [NSString stringWithFormat:@"%d",self.num];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:1 green:(255-log2(_num)*15)/255.0 blue:30/255.0 alpha:1];
    }
    return self;
}
-(instancetype)initWithPosition:(CGPoint)pos andSize:(CGFloat)w andNum:(int)number{
    
    if(self = [super initWithFrame:CGRectMake(pos.x+w/2, pos.y+w/2, 0, 0)])
    {
        _num = number;
        self.frame = CGRectMake(pos.x, pos.y, w, w);
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [[UIColor grayColor]CGColor];
        self.layer.masksToBounds = YES;
        self.text = [NSString stringWithFormat:@"%d",self.num];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:1 green:(255-log2(_num)*15)/255.0 blue:30/255.0 alpha:1];
    }
    return self;
}
-(void)refresh{
    self.text = [NSString stringWithFormat:@"%d",self.num];
    self.backgroundColor = [UIColor colorWithRed:1 green:(255-log2(_num)*15)/255.0 blue:30/255.0 alpha:1];
}

@end
