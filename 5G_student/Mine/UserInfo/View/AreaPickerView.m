//
//  AreaPickerView.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AreaPickerView.h"

@interface AreaPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray *dataArray1;
@property (nonatomic, strong) NSArray *dataArray2;
@property (nonatomic, strong) NSArray *areaArray1;
@property (nonatomic, strong) NSArray *areaArray2;
@property (nonatomic, assign) NSInteger selectedIndex1;
@property (nonatomic, assign) NSInteger selectedIndex2;

@end

@implementation AreaPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = [UIScreen mainScreen].bounds;
        UIView *topView = [KEY_WINDOW.subviews firstObject];
        [topView addSubview:self];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MScreenHeight, MScreenWidth, 300)];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        //工具栏取消和选择
        UIView * toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 45)];
        toolView.backgroundColor = MBackgroundColor;
        [contentView addSubview:toolView];
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(MMargin, 0, 100, toolView.height);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:MGrayTextColor forState:UIControlStateNormal];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:cancelButton];
        
        UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(MScreenWidth - 100 - MMargin, 0, 100, toolView.height);
        [selectButton setTitle:@"确定" forState:UIControlStateNormal];
        [selectButton setTitleColor:MDefaultColor forState:UIControlStateNormal];
        selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        selectButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [selectButton addTarget:self action:@selector(selectBarClicked) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:selectButton];
        
        //PickerView
        UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(toolView.frame), MScreenWidth, contentView.height - CGRectGetMaxY(toolView.frame))];
        self.pickerView = pickerView;
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [pickerView selectRow:0 inComponent:0 animated:NO];
        [contentView addSubview:pickerView];
        
        [self getAreaDataWithParentId:1];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getAreaDataWithParentId:(NSInteger)parentId
{
    NSDictionary *parameters = @{
        @"parentId": @(parentId)
    };
    [MBProgressHUD showMessage:@"" toView:self.contentView];
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/system/api/region/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.contentView];
        if (SUCCESS) {
            NSMutableArray *areaMuArr = [NSMutableArray array];
            for (NSDictionary * areaDic in json[@"data"][@"list"]) {
                [areaMuArr addObject:areaDic[@"mergerName"]];
            }
            if (parentId == 1) {
                self.dataArray1 = json[@"data"][@"list"];
                self.areaArray1 = [NSArray arrayWithArray:areaMuArr];
                [self.pickerView reloadComponent:0];
                
                if (self.dataArray1.count > 0) {
                    NSDictionary * areaDic = self.dataArray1[0];
                    [self getAreaDataWithParentId:[areaDic[@"id"] integerValue]];
                }
            }else
            {
                self.dataArray2 = json[@"data"][@"list"];
                self.areaArray2 = [NSArray arrayWithArray:areaMuArr];
                [self.pickerView selectRow:0 inComponent:1 animated:NO];
                [self.pickerView reloadComponent:1];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.contentView];
    }];
}

#pragma  mark - function
- (void)selectBarClicked
{
    if (self.block) {
        self.block(self.areaArray1[self.selectedIndex1], self.areaArray2[self.selectedIndex2]);
    }
    [self hide];
}

- (void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = MScreenHeight - self.contentView.height;
        self.backgroundColor = MColor(0, 0, 0, 0.4);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = MScreenHeight;
        self.backgroundColor = MColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.areaArray1.count;
    }
    return self.areaArray2.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.areaArray1[row];
    }
    return self.areaArray2[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = MBlackTextColor;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //刷新数据
    if (component == 0) {
        self.selectedIndex1 = row;
        
        NSDictionary * areaDic = self.dataArray1[row];
        [self getAreaDataWithParentId:[areaDic[@"id"] integerValue]];
    }else if (component == 1)
    {
        self.selectedIndex2 = row;
    }
}

#pragma mark - Getting
- (NSArray *)dataArray1
{
    if (!_dataArray1)
    {
        _dataArray1 = [NSArray array];
    }
    return _dataArray1;
}

- (NSArray *)dataArray2
{
    if (!_dataArray2)
    {
        _dataArray2 = [NSArray array];
    }
    return _dataArray2;
}

- (NSArray *)areaArray1
{
    if (!_areaArray1)
    {
        _areaArray1 = [NSArray array];
    }
    return _areaArray1;
}

- (NSArray *)areaArray2
{
    if (!_areaArray2)
    {
        _areaArray2 = [NSArray array];
    }
    return _areaArray2;
}


@end
