//
//  PageControl.h
//  YQUserCenter
//
//  Created by Wang on 16/8/2.
//  Copyright © 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void (^clickButtonBlock)(NSInteger index);
@end
