//
//  TableViewController.h
//  YQUserCenter
//
//  Created by Wang on 16/8/2.
//  Copyright © 2016年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
static CGFloat const kHeaderHeight = 240.0f;

@class TableViewController;

@protocol TableViewControllerDelegate <NSObject>

- (void)scrollView:(UIScrollView *)scrollView didScrollOffset:(CGPoint)offset inViewController:(TableViewController *)viewController;
- (void)scrollView:(UIScrollView *)scrollView didEndScrollInViewController:(TableViewController *)viewController;
@end

@interface TableViewController : UITableViewController
@property (strong, nonatomic)  HeaderView *headerView;
@property (weak, nonatomic) id<TableViewControllerDelegate> delegate;
@end
