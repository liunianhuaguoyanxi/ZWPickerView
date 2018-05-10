//
//  DomeViewController.m
//  ZWPickerView
//
//  Created by 流年划过颜夕 on 2018/4/18.
//  Copyright © 2018年 liunianhuaguoyanxi. All rights reserved.
//
#define Color(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#import "DomeViewController.h"
#import "ZWPickerView.h"
@interface DomeViewController ()<ZWPickerViewDelegate>
/** 城市列表 */
@property (nonatomic, strong) NSArray *cityListsArr;

/** 公司架构 */
@property (nonatomic, strong) NSArray *companyListsArr;
@end
@implementation DomeViewController
-(NSArray *)cityListsArr
{
    if (!_cityListsArr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"];
        _cityListsArr = [[NSArray alloc] initWithContentsOfFile:plistPath];

    }
    return _cityListsArr;
}
-(NSArray *)companyListsArr
{
    if (!_companyListsArr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"productList" ofType:@"plist"];
        _companyListsArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
    }
    return _companyListsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self setUpControlBtn];
    
    
}
-(void)initWithZWPickerViewWithCity
{
    ZWPickerView *view= [[ZWPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/2)];
    view.sourceArr=  self.cityListsArr;
    view.titleKeyName=@"name";
    view.subArrKeyName=@"childRen";
    view.delegate=self;
    [self.view addSubview:view];
}
-(void)initWithZWPickerViewWithCompany
{
    CGRect frame=CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/2);
    ZWPickerView *view= [[ZWPickerView alloc]initWithFrame:frame
                                        withTitleBarheight:40
                                       withTitleBtnSpacing:20
                                    withSegmentationheight:1
                                      withSliderViewheight:2
                                 withTitleBtnWidth:50
                                        withTitleBarheight:[UIFont systemFontOfSize:15]];

    view.frame=CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/2);
    view.sourceArr=  self.companyListsArr;
    view.titleKeyName=@"name";
    view.subArrKeyName=@"childRen";
    view.delegate=self;
    [self.view addSubview:view];
    

}
-(void)setUpControlBtn
{
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 30, 300, 100)];
    lab.backgroundColor=Color(236, 93, 78, 1);
    [self.view addSubview:lab];
    lab.backgroundColor=[UIColor clearColor];
    lab.textColor=[UIColor whiteColor];
    lab.numberOfLines=0;
    lab.text=@"ZWPickerView选择器\n\n 两个典型实例\n(Two Typical Examples)";
    lab.textAlignment=NSTextAlignmentCenter;

    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 200, 300, 50)];
    btn.backgroundColor=Color(236, 93, 78, 1);
    [self.view addSubview:btn];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.titleLabel.numberOfLines=0;
    [btn setTitle:@"城市选择器\n省市区三层延展，可用于项目" forState:0];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=15;

    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 300, 300, 50)];
    btn1.backgroundColor=Color(236, 93, 78, 1);
    [self.view addSubview:btn1];
    btn1.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"公司架构选择器\n无限动态子类延伸" forState:0];
    btn1.titleLabel.numberOfLines=0;
    btn1.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn1.layer.masksToBounds=YES;
    btn1.layer.cornerRadius=15;
}
-(void)clickBtn
{
    [self initWithZWPickerViewWithCity];
}

-(void)clickBtn1
{
    [self initWithZWPickerViewWithCompany];
}
#//=================================================================
//                           ZWPickerViewDelegate
//=================================================================
#pragma mark - ZWPickerViewDelegate
-(void)ZWPickerViewDelegateClickToCloseZWPickerView:(ZWPickerView *)pickerView WithTotalTitleArr:(NSArray *)totalTitleArr withSelectItem:(NSDictionary *)selectItem
{
    NSString *allTitleText;
    for (int i=0; i<totalTitleArr.count; i++) {
        if (allTitleText.length>0) {
            allTitleText=[NSString stringWithFormat:@"%@-%@",allTitleText,totalTitleArr[i]];
        }else
        {
           allTitleText=[NSString stringWithFormat:@"%@",totalTitleArr[i]];
        }
    }
    NSLog(@"\n您选择的是总标题:\n%@\n子标题为:\n%@",allTitleText,totalTitleArr.lastObject);
}


@end
