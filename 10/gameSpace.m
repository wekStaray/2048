//
//  gameSpace.m
//  10
//
//  Created by bytedance on 2020/8/3.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "gameSpace.h"
#import "slider.h"
#import <Masonry/Masonry.h>
#import <Foundation/Foundation.h>
@interface gameSpace()
@property(nonatomic,assign) int lineBlockNum;
@property(nonatomic,assign) CGFloat blockWidth;
@property(nonatomic,strong) NSMutableDictionary *dir;
@property(nonatomic,assign) CGPoint pos;
@property(nonatomic,assign) BOOL isSlide,isSuccessSlide;

-(int)findPositionWithX:(int)x AndY:(int)y;
@end

@implementation gameSpace
-(int)findPositionWithX:(int)x AndY:(int)y{
    return x * _lineBlockNum + y ;
}
-(void)layout:(int)num{
    
    self.dir = [NSMutableDictionary new];
    
    self.lineBlockNum = num;
    
    self.blockWidth = (self.frame.size.width-(self.lineBlockNum+1)*5)/self.lineBlockNum;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    
    for(int i = 0; i < self.lineBlockNum * self.lineBlockNum; i++){
        
        int x = i/self.lineBlockNum, y = i%self.lineBlockNum;
        
         UIView * block = [UIView new];
        block.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        block.layer.masksToBounds = YES;
        block.layer.cornerRadius = 3;
        block.tag = i + 1;
        [self addSubview:block];
        [block mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(x * self.blockWidth + (x+1) * 5);
            make.left.mas_equalTo(y * self.blockWidth + (y+1) * 5);
            make.height.width.mas_equalTo(self.blockWidth);
        }];
    }
    [self layoutIfNeeded];
}


-(int)findRandomEmptyPlace{
    int q[(_lineBlockNum+1)*(_lineBlockNum+1)];
    int top = 0, temp;
    
    for(int i = 0; i < self.lineBlockNum; i++)
        for(int j = 0; j < self.lineBlockNum; j++){
            
            temp = [self findPositionWithX:i AndY:j];
            
            id tmp = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
            
            if(tmp == nil)
                q[top++] = temp;
        }
    
    if(top == 0) return -1;
    
    return q[arc4random()%top];
}

-(void)createNewNumberBlockWithpos:(int)temp{
    
    if(temp < 0) return;
    
    int y = temp/_lineBlockNum * self.blockWidth + (temp/_lineBlockNum+1) * 5;
    int x = temp%_lineBlockNum * self.blockWidth + (temp%_lineBlockNum+1) * 5;
    
    slider *numBlock = [[slider alloc]initWithPosition:CGPointMake(x, y) andSize:_blockWidth];
    
    numBlock.tag = temp * 2 + 2;
    
    [self addSubview:numBlock];
    
    [self layoutIfNeeded];
    
    [self.dir setObject:numBlock forKey: [NSString stringWithFormat:@"%d",temp]];
    
}

-(void)createNewNumberBlockWithpos:(int)temp andNum:(int)number{
    
    if(temp < 0) return;
    
    int y = temp/_lineBlockNum * self.blockWidth + (temp/_lineBlockNum+1) * 5;
    int x = temp%_lineBlockNum * self.blockWidth + (temp%_lineBlockNum+1) * 5;
    
    slider *numBlock = [[slider alloc]initWithPosition:CGPointMake(x, y) andSize:_blockWidth andNum:number];
    
    numBlock.tag = temp * 2 + 2;
    
    [self addSubview:numBlock];
    
    [self layoutIfNeeded];
    
    [self.dir setObject:numBlock forKey: [NSString stringWithFormat:@"%d",temp]];
    
}

-(void)slideUp{
    
    int temp,now;
    slider *first,*second;
    
    for(int i = 0; i < _lineBlockNum; i++){
        
        first = second = nil;
        now = 0;
        
        for(int j = 0; j < _lineBlockNum; j++){
            
            temp = [self findPositionWithX:j AndY:i];
            
            if(first == nil){
                first = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            else{
                second = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            if(first != nil && second != nil)
            if(first.num == second.num){
                
                temp = [self findPositionWithX:now AndY:i]+1;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [second mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [first removeFromSuperview];
                    [second removeFromSuperview];
                    
                    [self createNewNumberBlockWithpos:temp-1 andNum:first.num*2];
                }];
                
                _score += first.num;
                
                first = second = nil;
                now++;
                
                _isSuccessSlide = YES;
            }
            else{
                temp = [self findPositionWithX:now AndY:i]+1;
                
                CGPoint last = first.frame.origin;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
                
                CGPoint next = first.frame.origin;
                if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                    _isSuccessSlide = YES;
                
                
                first = second;
                second = nil;
                now++;
            }
            
        }
        
        if (first != nil){
            temp = [self findPositionWithX:now AndY:i]+1;
            
            CGPoint last = first.frame.origin;
            
            [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            }];
            
            [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
            
            CGPoint next = first.frame.origin;
            if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                _isSuccessSlide = YES;
            
        }
    }
    
            
    _isSlide = YES;
    
}
-(void)slideDown{
    
    int temp,now;
    slider *first,*second;
    
    for(int i = 0; i < _lineBlockNum; i++){
        
        first = second = nil;
        now = _lineBlockNum - 1;
        
        for(int j = _lineBlockNum - 1; j >= 0; j--){
            
            temp = [self findPositionWithX:j AndY:i];
            
            if(first == nil){
                first = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            else{
                second = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            if(first != nil && second != nil)
            if(first.num == second.num){
                
                temp = [self findPositionWithX:now AndY:i]+1;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [second mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [UIView animateWithDuration:0.1 animations:^{
                    [first removeFromSuperview];
                    [second removeFromSuperview];
                    
                    [self createNewNumberBlockWithpos:temp-1 andNum:first.num*2];
                }];
                
                _score += first.num;
                
                first = second = nil;
                now--;
            }
            else{
                temp = [self findPositionWithX:now AndY:i]+1;
                
                CGPoint last = first.frame.origin;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
                
                CGPoint next = first.frame.origin;
                if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                    _isSuccessSlide = YES;
                
                
                first = second;
                second = nil;
                now--;
            }
            
        }
        
        if (first != nil){
            temp = [self findPositionWithX:now AndY:i]+1;
            
            CGPoint last = first.frame.origin;
            
            [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            }];
            
            [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
            
            CGPoint next = first.frame.origin;
            if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                _isSuccessSlide = YES;
            
        }
    }
        
            
    _isSlide = YES;
    
}
-(void)slideRight{
    
    int temp,now;
    slider *first,*second;
    
    for(int i = 0; i < _lineBlockNum; i++){
        
        first = second = nil;
        now = _lineBlockNum - 1;
        
        for(int j = _lineBlockNum - 1; j >= 0; j--){
            
            temp = [self findPositionWithX:i AndY:j];
            
            if(first == nil){
                first = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            else{
                second = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            if(first != nil && second != nil)
            if(first.num == second.num){
                
                temp = [self findPositionWithX:i AndY:now]+1;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [second mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [UIView animateWithDuration:0.1 animations:^{
                    [first removeFromSuperview];
                    [second removeFromSuperview];
                    
                    [self createNewNumberBlockWithpos:temp-1 andNum:first.num*2];
                }];
                _score += first.num;
                
                _isSuccessSlide = YES;
                first = second = nil;
                now--;
            }
            else{
                temp = [self findPositionWithX:i AndY:now]+1;
                
                CGPoint last = first.frame.origin;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
                
                CGPoint next = first.frame.origin;
                if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                    _isSuccessSlide = YES;
                
                first = second;
                second = nil;
                now--;
            }
            
        }
        
        if (first != nil){
            temp = [self findPositionWithX:i AndY:now]+1;
            
            CGPoint last = first.frame.origin;
            
            [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            }];
            
            [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
            
            CGPoint next = first.frame.origin;
            if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                _isSuccessSlide = YES;
            
            [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
        }
    }
        
            
    _isSlide = YES;
    
}
-(void)slideLeft{
    
    int temp,now;
    slider *first,*second;
    
    for(int i = 0; i < _lineBlockNum; i++){
        
        first = second = nil;
        now = 0;
        
        for(int j = 0; j < _lineBlockNum; j++){
            
            temp = [self findPositionWithX:i AndY:j];
            
            if(first == nil){
                first = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            else{
                second = [self.dir objectForKey:[NSString stringWithFormat:@"%d",temp]];
                [self.dir removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
            }
            if(first != nil && second != nil)
            if(first.num == second.num){
                
                temp = [self findPositionWithX:i AndY:now]+1;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [second mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [UIView animateWithDuration:0.1 animations:^{
                    [first removeFromSuperview];
                    [second removeFromSuperview];
                    
                    [self createNewNumberBlockWithpos:temp-1 andNum:first.num*2];
                }];
                _score += first.num;
                _isSuccessSlide = YES;
                first = second = nil;
                now++;
            }
            else{
                temp = [self findPositionWithX:i AndY:now]+1;
                
                CGPoint last = first.frame.origin;
                
                [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self layoutIfNeeded];
                }];
                
                [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
                
                CGPoint next = first.frame.origin;
                if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                    _isSuccessSlide = YES;
                
                first = second;
                second = nil;
                now++;
            }
            
        }
        
        if (first != nil){
            temp = [self findPositionWithX:i AndY:now]+1;
            
            CGPoint last = first.frame.origin;
            
            [first mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo([self viewWithTag:temp]);
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            }];
            
            [self.dir setObject:first forKey:[NSString stringWithFormat:@"%d",temp-1]];
            
            CGPoint next = first.frame.origin;
            if(fabs(last.x - next.x) > 1 || fabs(last.y - next.y) > 1)
                _isSuccessSlide = YES;
            
        }
    }
        
            
    _isSlide = YES;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    _isSuccessSlide = NO;
    _pos = [t locationInView:t.view.superview];
}

- (void)startGame{
    
        for (id key in self.dir)
        {
            slider *i = [self.dir objectForKey:key];
            if(i != nil)
               [i removeFromSuperview];
        }
            
        
        [self.dir removeAllObjects];
    
    
    _score = 0;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self createNewNumberBlockWithpos: [self findRandomEmptyPlace]];
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    CGPoint temp = [t locationInView:t.view.superview];

    CGFloat offx = temp.x - _pos.x;
    CGFloat offy = temp.y - _pos.y;

    if(_isSlide) return;

    if(fabs(offx) > 50){
        if(offx > 0)
           [self slideRight];
        else
            [self slideLeft];
        }
        else if(fabs(offy) > 50){
            if(offy > 0)
                    [self slideDown];
            else
                [self slideUp];
        }
    
    if(_isSuccessSlide){
        [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [UIView animateWithDuration:0.2 animations:^{
                [self createNewNumberBlockWithpos: [self findRandomEmptyPlace]];
            }];
        }];
    }


}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isSlide = NO;
}
@end
