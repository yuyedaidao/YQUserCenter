//
//  PageViewController.m
//  YQUserCenter
//
//  Created by Wang on 16/8/2.
//  Copyright © 2016年 Wang. All rights reserved.
//

#import "PageViewController.h"
#import "TableViewController.h"
#import "PageControl.h"
static CGFloat const kPageControlHeight = 36.0f;
@interface PageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, TableViewControllerDelegate>
@property (strong, nonatomic) NSArray *contentViewControllers;
@property (strong, nonatomic) PageControl *pageControl;
@property (strong, nonatomic) UIImageView *fakeHeaderImgView;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    

    NSMutableArray *viewControllers = @[].mutableCopy;
    
    for (int i = 0; i < 3; i++) {
        TableViewController *vc = [[TableViewController alloc] init];
        vc.delegate = self;
        vc.title = [NSString stringWithFormat:@"Title%@",@(i)];
        [viewControllers addObject:vc];
    }
    self.contentViewControllers = viewControllers;
    [self setViewControllers:@[self.contentViewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.fakeHeaderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeaderHeight)];
    self.fakeHeaderImgView.hidden = YES;
    [self.view addSubview:self.fakeHeaderImgView];
    
    self.pageControl = ({
        PageControl *pageControl = [[NSBundle mainBundle] loadNibNamed:@"PageControl" owner:nil options:nil].lastObject;
        pageControl.selectedIndex = 0;
        [self.view addSubview:pageControl];
        pageControl.frame = CGRectMake(0, kHeaderHeight - kPageControlHeight, self.view.bounds.size.width, kPageControlHeight);//妈蛋不知道为什么这里设置高度竟然不起作用
        __weak typeof(self) ws = self;
        [pageControl setClickButtonBlock:^(NSInteger index) {
            __strong typeof(ws) self = ws;
            NSInteger oldIndex = [self.contentViewControllers indexOfObject:self.viewControllers.firstObject];
            if (oldIndex != index) {
                [self showFakeHeaderView];
                __weak typeof(self) ws = self;
                [self setViewControllers:@[self.contentViewControllers[index]] direction:oldIndex < index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                    __strong typeof(ws) self = ws;
                    [self hideFakeHeaderView];
                }];
            }
        }];
        pageControl;
    });
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.pageControl.frame;
    frame.size.height = kPageControlHeight;
    self.pageControl.frame = frame;
}

#pragma mark helper
- (void)showFakeHeaderView {
    UIView *view = [(TableViewController *)self.viewControllers.firstObject headerView];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.fakeHeaderImgView.image = image;
    CGRect frame = self.fakeHeaderImgView.frame;
    frame.origin.y = self.pageControl.frame.origin.y - kHeaderHeight + kPageControlHeight;
    self.fakeHeaderImgView.frame = frame;
    self.fakeHeaderImgView.hidden = NO;
}

- (void)hideFakeHeaderView {
    self.fakeHeaderImgView.hidden = YES;
}

#pragma mark table delegate
- (void)scrollView:(UITableView *)scrollView didScrollOffset:(CGPoint)offset inViewController:(TableViewController *)viewController{
    CGFloat height = kHeaderHeight - kPageControlHeight;
    if (offset.y <= height) {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = height - offset.y;
        self.pageControl.frame = frame;
    } else {
        CGRect frame = self.pageControl.frame;
        frame.origin.y = 0;
        self.pageControl.frame = frame;
    }
}

- (void)scrollView:(UIScrollView *)scrollView didEndScrollInViewController:(TableViewController *)viewController {
    //判断其他视图位置是否合适
//    CGFloat height = kHeaderHeight - kPageControlHeight;
    [self.contentViewControllers enumerateObjectsUsingBlock:^(TableViewController  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != viewController) {
            obj.tableView.contentOffset = scrollView.contentOffset;//TODO::这个策略过于简单,可以优化
        }
    }];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [self showFakeHeaderView];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self hideFakeHeaderView];
    NSInteger index = [self.contentViewControllers indexOfObject:self.viewControllers.firstObject];
    self.pageControl.selectedIndex = index;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index + 1 < self.contentViewControllers.count) {
        return self.contentViewControllers[index + 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index > 0 ) {
        return self.contentViewControllers[index - 1];
    }
    return nil;
}



@end
