//
//  PageControl.m
//  YQUserCenter
//
//  Created by Wang on 16/8/2.
//  Copyright © 2016年 Wang. All rights reserved.
//

#import "PageControl.h"

@interface PageControl ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation PageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClick:(UIButton *)sender {
    self.selectedIndex = sender.tag;
    !self.clickButtonBlock ? : self.clickButtonBlock(sender.tag);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    NSAssert(selectedIndex < self.buttons.count, @"越界了");
    _selectedIndex = selectedIndex;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj.tag == selectedIndex;
    }];
}

@end
