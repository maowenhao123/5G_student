//
//  SearchViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setShadowImage:[UIImage new]];
    
    if (MStringIsEmpty(self.searchBar.text)) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setShadowImage:nil];
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.searchBar];
}

#pragma mark - Getting
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, MStatusBarH, MScreenWidth - 2 * 10, MNavBarH)];
        _searchBar.placeholder = @"搜老师/课程";
        _searchBar.showsCancelButton = YES;
        _searchBar.tintColor = MDefaultColor;
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [UIImage new];
        UITextField * searchTextField = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0) {
            searchTextField = (UITextField *)[self findViewWithClassName:@"UITextField" inView:_searchBar];
        }else
        {
            searchTextField = [_searchBar valueForKey:@"_searchField"];
        }
        if (!MObjectIsEmpty(searchTextField)) {
            searchTextField.backgroundColor = UIColorFromRGB(0xF0F1F3);
            searchTextField.font = [UIFont systemFontOfSize:15];
            searchTextField.layer.cornerRadius = 1;
            searchTextField.layer.masksToBounds = YES;
        }
    }
    return _searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通过类名找view的subview
- (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view
{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }
    
    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findViewWithClassName:className inView:subView];
            if (targetView != nil) {
                return targetView;
            }
        }
    }
    return nil;
}



@end
