//
//  ZWPickerView.m
//  ZWPickerView
//
//  Created by 流年划过颜夕 on 2018/4/18.
//  Copyright © 2018年 liunianhuaguoyanxi. All rights reserved.
//
#define ZWColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define ZWSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define ZWSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#import "ZWPickerView.h"
#import "ZWPickerButton.h"


@interface ZWPickerView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
        BOOL    isSelectCell;
    CGFloat initSliderWidth;
    CGFloat animationTimes;
}
/** currentChooseCount */
@property (nonatomic, assign) int        currentChooseCount;
/** indexBtnCount */
@property (nonatomic, assign) int        indexBtnCount;
/** indexTableViewCount */
@property (nonatomic, assign) int        indexTableViewCount;
/** titleBtnWidth */
@property (nonatomic, assign) CGFloat    titleBtnWidth;
/** titleBarheight */
@property (nonatomic, assign) CGFloat    titleBarheight;
/** segmentationheight */
@property (nonatomic, assign) CGFloat    segmentationheight;
/** sliderViewheight */
@property (nonatomic, assign) CGFloat    sliderViewheight;
/** titleBtnX */
@property (nonatomic, assign) CGFloat    titleBtnX;
/** titleBtnSpacing */
@property (nonatomic, assign) CGFloat    titleBtnSpacing;
/** tableContentView */
@property (nonatomic, weak) UIScrollView *tableContentView;
/** tableContentView */
@property (nonatomic, weak) UIScrollView *titleContentView;
/** currentTableView */
@property (nonatomic, weak) UITableView  *currentTableView;
/** completeBtn */
@property (nonatomic, weak) UIButton     *completeBtn;
/** segmentationView */
@property (nonatomic, weak) UIView       *segmentationView;
/** sliderView */
@property (nonatomic, weak) UIView       *sliderView;
/** titleBarFont */
@property (nonatomic, strong) UIFont     *titleBarFont;
/** titleBtnsMutableArr */
@property (nonatomic, strong) NSMutableArray *titleBtnsMutableArr;
/** tableViewsMutableArr */
@property (nonatomic, strong) NSMutableArray *tableViewsMutableArr;
/** ChangeArr */
@property (nonatomic, strong) NSMutableArray *allArrContainerMutableArr;
/** selectLastDic */
@property (nonatomic, strong) NSDictionary   *selectLastDic;
@end
@implementation ZWPickerView

- (NSMutableArray *)titleBtnsMutableArr{
    
    if (_titleBtnsMutableArr == nil) {
        _titleBtnsMutableArr = [NSMutableArray array];
    }
    return _titleBtnsMutableArr;
}


- (NSMutableArray *)tableViewsMutableArr{
    
    if (_tableViewsMutableArr == nil) {
        _tableViewsMutableArr = [NSMutableArray array];
    }
    return _tableViewsMutableArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpPreferences];
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
           withTitleBarheight:(CGFloat)titleBarheigh
          withTitleBtnSpacing:(CGFloat)titleBtnSpacing
       withSegmentationheight:(CGFloat)segmentationheight
         withSliderViewheight:(CGFloat)sliderViewheight
            withTitleBtnWidth:(CGFloat)titleBtnWidth
           withTitleBarheight:(UIFont *)titleBarFont;

{
    if ([super initWithFrame:frame]) {
        [self setUpPreferences];
        self.titleBarheight = titleBarheigh;
        self.titleBtnSpacing = titleBtnSpacing;
        self.segmentationheight = segmentationheight;
        self.sliderViewheight = sliderViewheight;
        self.titleBarFont = titleBarFont;
        self.titleBtnWidth = titleBtnWidth;
        [self setUpView];
    }
    return self;
}

-(void)setUpPreferences
{
    self.backgroundColor=[UIColor whiteColor];
    
    [self setUpTitleContentView];
    animationTimes=0.3;
    
    self.indexBtnCount=0;
    self.indexTableViewCount=0;
    self.currentChooseCount=0;
}

-(void)setUpTitleContentView
{
    self.titleBarheight =40;
    
    self.titleBtnSpacing =10;
    
    
    self.segmentationheight=0.5;
    
    self.sliderViewheight=2;
    
    self.titleBarFont=[UIFont systemFontOfSize:13];
    
    
    self.titleBtnWidth=50;
}
-(void)setUpView
{
    [self setUpContentView];
    [self setUpChildView];
}

-(void)setUpContentView
{

    UIView *segmentationBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.titleBarheight-self.segmentationheight, self.frame.size.width, self.segmentationheight)];
    segmentationBottomView.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:segmentationBottomView];

    UIScrollView *titleContentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-self.titleBtnWidth, self.titleBarheight)];
    titleContentView.showsVerticalScrollIndicator=NO;
    titleContentView.showsHorizontalScrollIndicator=NO;
    titleContentView.backgroundColor=[UIColor whiteColor];
    titleContentView.bounces=YES;
    titleContentView.delegate=self;
    [self addSubview:titleContentView];
    self.titleContentView=titleContentView;
    
    UIView *segmentationView=[[UIView alloc]initWithFrame:CGRectMake(0, self.titleBarheight-self.segmentationheight, self.frame.size.width, self.segmentationheight)];
    segmentationView.backgroundColor=[UIColor lightGrayColor];
    [self.titleContentView addSubview:segmentationView];
    self.segmentationView=segmentationView;

    UIButton *completeBtn=[UIButton buttonWithType:0];
    completeBtn.backgroundColor=[UIColor clearColor];
    [completeBtn setTitleColor:[UIColor blackColor] forState:0];
    [completeBtn setTitle:@"确定" forState:0];
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    completeBtn.frame=CGRectMake(self.frame.size.width-self.titleBtnWidth, 0, self.titleBtnWidth, self.titleBarheight);
    [completeBtn addTarget:self action:@selector(clickToFinish) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeBtn];
    self.completeBtn=completeBtn;

    UIScrollView *tableContentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titleBarheight, self.frame.size.width, self.frame.size.height-self.titleBarheight)];
    tableContentView.showsVerticalScrollIndicator=NO;
    tableContentView.showsHorizontalScrollIndicator=NO;
    tableContentView.bounces = NO; // 去除弹簧效果
    tableContentView.pagingEnabled = YES;
    tableContentView.backgroundColor=[UIColor whiteColor];
    [self addSubview:tableContentView];
    tableContentView.delegate = self;
    self.tableContentView=tableContentView;
    

}

-(void)setUpChildView
{
    
    [self initCurrentTableView];
    [self initTableViewWithIndex:0];
    [self initTitleBtn:self.indexBtnCount withTextStr:@"请选择"];
    [self initsliderView];

}
-(void)initsliderView
{

    UIView *sliderView=[[UIView alloc]initWithFrame:CGRectMake(self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, initSliderWidth, self.sliderViewheight)];
    sliderView.backgroundColor=[UIColor redColor];
    [self.titleContentView addSubview:sliderView];
    self.sliderView=sliderView;
}
-(void)initTitleBtn:(int)index withTextStr:(NSString *)text
{
    if (index==0) {
        initSliderWidth=[self calculateRowWidth:text]+self.titleBtnSpacing;
    }
    ZWPickerButton *titleBtn=[[ZWPickerButton alloc]initWithFrame:CGRectMake(self.titleBtnSpacing+self.titleBtnX, 0, [self calculateRowWidth:text], self.titleBarheight-self.sliderViewheight)];
    [titleBtn addTarget:self action:@selector(clickToSwitchTableView:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.titleLabel.font=self.titleBarFont;
    titleBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleBtn setTitle:text forState:0];
    titleBtn.backgroundColor=[UIColor whiteColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:0];
    titleBtn.index=index;
    [self.titleContentView addSubview: titleBtn];
    [self.titleBtnsMutableArr addObject:titleBtn];
    self.titleBtnX+=([self calculateRowWidth:text]+self.titleBtnSpacing);
//    NSLog(@"%@ titleBtn.titleLabel.text",titleBtn.titleLabel.text);
    if (self.titleBtnX>self.titleContentView.frame.size.width) {
        self.titleContentView.contentSize=CGSizeMake(self.titleBtnX+self.titleBtnSpacing, 0);
        self.segmentationView.frame=CGRectMake(0, self.titleBarheight-self.segmentationheight, self.titleBtnX+self.frame.size.width, self.segmentationheight);
    }
    self.indexBtnCount=(int)self.titleBtnsMutableArr.count;
}

-(void)initTableViewWithIndex:(int)index
{

    [self.tableViewsMutableArr addObject:[NSNumber numberWithInt:index]];
    self.tableContentView.contentSize=CGSizeMake((index+1)*self.frame.size.width, 0);
    [self.tableContentView setContentOffset:CGPointMake(index*self.frame.size.width, 0)];
    self.currentTableView.frame=CGRectMake(index*self.frame.size.width,0 , self.frame.size.width, self.tableContentView.frame.size.height-10);
    self.indexTableViewCount=(int)self.tableViewsMutableArr.count;
}

-(void)initCurrentTableView
{
    UITableView *childTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0 , self.frame.size.width, self.tableContentView.frame.size.height-10)];
    childTableView.dataSource = self;
    childTableView.delegate = self;
    childTableView.rowHeight = 40;
    childTableView.separatorStyle = NO;
    childTableView.showsVerticalScrollIndicator = NO;
    childTableView.bounces = NO;
    childTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    childTableView.backgroundColor = [UIColor whiteColor];
    [self.tableContentView addSubview: childTableView];
    self.tableContentView.contentSize=CGSizeMake(self.frame.size.width, 0);
    self.currentTableView=childTableView;
}

-(void)clickToSwitchTableView:(ZWPickerButton *)sender
{
    self.tableContentView.userInteractionEnabled=NO;
    ZWPickerButton *tmpBtn=sender;
    [UIView animateWithDuration:animationTimes animations:^{
        self.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);
    }];
    [self refreshContenOffsetWithButton:tmpBtn];
    [self.tableContentView setContentOffset:CGPointMake(tmpBtn.index*ZWSCREEN_WIDTH, 0) animated:NO];
    self.currentChooseCount=tmpBtn.index;
    self.tableContentView.userInteractionEnabled=YES;
    self.currentTableView.frame=CGRectMake(tmpBtn.index*self.frame.size.width,0 , self.frame.size.width, self.tableContentView.frame.size.height-10);
    [self.currentTableView reloadData];
//    NSLog(@"self.currentChooseCount %D clickToSwitchTableView",self.currentChooseCount);
}
-(void)clickToFinish
{

    NSMutableArray *tmpArr=[NSMutableArray array];
    for (int i=0;  i<self.titleBtnsMutableArr.count;i++) {
        ZWPickerButton *tmpBtn=self.titleBtnsMutableArr[i];
        if (![tmpBtn.titleLabel.text isEqualToString:@"请选择"]&&tmpBtn.titleLabel.text.length>0) {
            [tmpArr addObject:tmpBtn.titleLabel.text];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(ZWPickerViewDelegateClickToCloseZWPickerView:WithTotalTitleArr:withSelectItem:)]) {
        
        
        [self.delegate ZWPickerViewDelegateClickToCloseZWPickerView:self WithTotalTitleArr:[NSArray arrayWithArray:tmpArr] withSelectItem:self.selectLastDic];
    }
        [self removeFromSuperview];
}

#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *tmpMutableArr=self.allArrContainerMutableArr[self.currentChooseCount];
    return tmpMutableArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const ID = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *tmpMutableArr=self.allArrContainerMutableArr[self.currentChooseCount];
    if (tmpMutableArr.count>0) {
#pragma mark ToDoZWPickerView//根据传入格式设置cell
        
        
        
        
        NSDictionary *tmpDic=tmpMutableArr[indexPath.row];
        cell.textLabel.text=[tmpDic objectForKey:self.titleKeyName];
        
////////////////////////////////
        
    }
    return  cell;
}
#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (isSelectCell==NO) {
        isSelectCell=YES;
        NSNumber *tmpNumber=self.tableViewsMutableArr[self.currentChooseCount];
        
        //如果点击的是最末尾的tableVeiw（有子类则动态添加tableview和titleBAR）
        if([tmpNumber integerValue]==self.indexTableViewCount-1) {
            
            NSMutableArray *tmpMutableArr=self.allArrContainerMutableArr[self.currentChooseCount];
            if (tmpMutableArr.count>0) {
                
#pragma mark ToDoZWPickerView//根据传入格式设置cell
                
                NSDictionary *tmpDic=tmpMutableArr[indexPath.row];
                NSString *currentTitle=[tmpDic objectForKey:self.titleKeyName];
                
                //如果点击后有儿子，则添加请选择，反之则返回
                NSArray *changeArr=[tmpDic objectForKey:self.subArrKeyName];
                
////////////////////////////////
                //更新当前父亲的title
                [self updateParentButtonTitleWithIndex:[tmpNumber intValue] With:currentTitle];
                
                self.selectLastDic=[NSDictionary dictionaryWithDictionary:tmpDic];
                if (changeArr.count>0) {
                    [self.allArrContainerMutableArr addObject:[NSArray arrayWithArray:changeArr]];
                    
                    [self initTableViewWithIndex:self.indexTableViewCount];
                    [self initTitleBtn:self.indexBtnCount withTextStr:[NSString stringWithFormat:@"%@",@"请选择"]];
                }else
                {
                    ZWPickerButton * tmpBtn = self.titleBtnsMutableArr[[tmpNumber integerValue]];
                    [UIView animateWithDuration:animationTimes animations:^{
                        self.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);
                        [self refreshContenOffsetWithButton:tmpBtn];
                    }];
                    isSelectCell=NO;
                    return;
                }
            }else{
                isSelectCell=NO;
                return;
            }
            
            
            
            
            
            
        }
        //如果点击的是不是最末尾的tableVeiw（移除其孙子类的所有tableView标示符和titleBAR，在判断如果有子类则动态添加tableview标示符和titleBAR）
        else if (([tmpNumber integerValue]<self.indexTableViewCount-1)&&([tmpNumber integerValue]<self.indexBtnCount-1))
        {
            
            int allCount=(int)self.tableViewsMutableArr.count;
            //移除数组中的ZWPickerTableView和控件中的WPickerTableView
            [self.tableViewsMutableArr  removeObjectsInRange:NSMakeRange([tmpNumber integerValue]+1, self.indexTableViewCount-[tmpNumber integerValue]-1)];
            self.indexTableViewCount=(int)self.tableViewsMutableArr.count;
            
            //移除数组中的ZWPickerButton和控件中的ZWPickerButton，并重新计算其frame
            for (ZWPickerButton *tmpBtn in self.titleBtnsMutableArr) {
                if (tmpBtn.index>[tmpNumber integerValue]) {
                    [tmpBtn removeFromSuperview];
                    self.titleBtnX-=([self calculateRowWidth:tmpBtn.titleLabel.text]+self.titleBtnSpacing);
                }
            }
            [self.titleBtnsMutableArr  removeObjectsInRange:NSMakeRange([tmpNumber integerValue]+1, self.indexBtnCount-[tmpNumber integerValue]-1)];
            
            self.indexBtnCount=(int)self.titleBtnsMutableArr.count;
            
            
            
            
            
            
            
            
            
            
            
            [self.allArrContainerMutableArr  removeObjectsInRange:NSMakeRange([tmpNumber integerValue]+1, allCount-[tmpNumber integerValue]-1)];
            
            
            
            if (self.currentChooseCount>self.allArrContainerMutableArr.count) {
                isSelectCell=NO;
                return;
            }
            
            
            NSMutableArray *tmpMutableArr=self.allArrContainerMutableArr[self.currentChooseCount];

#pragma mark ToDoZWPickerView//根据传入格式设置cell
            
            NSDictionary *tmpDic=tmpMutableArr[indexPath.row];
            NSString *currentTitle=[tmpDic objectForKey:self.titleKeyName];

            
            //如果点击后有儿子，则添加请选择，反正返回
            tmpMutableArr=[tmpDic objectForKey:self.subArrKeyName];
            
           
////////////////////////////////
            //更新当前父亲的title
            [self updateParentButtonTitleWithIndex:[tmpNumber intValue] With:currentTitle];
            
            self.selectLastDic=[NSDictionary dictionaryWithDictionary:tmpDic];
            if (tmpMutableArr.count>0) {
                [self.allArrContainerMutableArr addObject:[NSArray arrayWithArray:tmpMutableArr]];
                
                [self initTableViewWithIndex:self.indexTableViewCount];
                [self initTitleBtn:self.indexBtnCount withTextStr:[NSString stringWithFormat:@"%@",@"请选择"]];
            }else
            {
                ZWPickerButton * tmpBtn = self.titleBtnsMutableArr[[tmpNumber integerValue]];
                [UIView animateWithDuration:animationTimes animations:^{
                    self.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);
                }];
                isSelectCell=NO;
                return;
            }
        }
        
        //如果成功，则自动跳转过去
        
        ZWPickerButton * tmpBtn = self.titleBtnsMutableArr.lastObject;
        [UIView animateWithDuration:animationTimes animations:^{
            self.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);
        }];
        [self refreshContenOffsetWithButton:tmpBtn];
        [self.tableContentView setContentOffset:CGPointMake(tmpBtn.index*ZWSCREEN_WIDTH, 0) animated:NO];
        self.currentTableView.frame=CGRectMake(tmpBtn.index*self.frame.size.width,0 , self.frame.size.width, self.tableContentView.frame.size.height-10);
        self.currentChooseCount+=1;
        [self.currentTableView reloadData];
//        NSLog(@"self.currentChooseCount %D didSelectRowAtIndexPath",self.currentChooseCount);
      
    }
    
    isSelectCell=NO;

}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != self.tableContentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:animationTimes animations:^{
        NSInteger index = self.tableContentView.contentOffset.x / ZWSCREEN_WIDTH;
        if (index<self.allArrContainerMutableArr.count) {
            ZWPickerButton * tmpBtn = weakSelf.titleBtnsMutableArr[index];
            weakSelf.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);

            [self refreshContenOffsetWithButton:tmpBtn];


//            NSLog(@"self.currentChooseCount %D scrollViewDidEndDecelerating",self.currentChooseCount);
        }else
        {
            ZWPickerButton * tmpBtn = weakSelf.titleBtnsMutableArr[self.allArrContainerMutableArr.count-1];
            weakSelf.sliderView.frame=CGRectMake(tmpBtn.frame.origin.x-self.titleBtnSpacing/2, self.titleBarheight-self.sliderViewheight, tmpBtn.frame.size.width+self.titleBtnSpacing, self.sliderViewheight);

            [self refreshContenOffsetWithButton:tmpBtn];


        }

    }];
            NSInteger index = self.tableContentView.contentOffset.x / ZWSCREEN_WIDTH;
    if (index<self.allArrContainerMutableArr.count) {
        self.currentChooseCount=(int)index;;
        [self.tableContentView setContentOffset:CGPointMake(index*self.frame.size.width, 0) animated:NO];
        self.currentTableView.frame=CGRectMake(index*self.frame.size.width,0 , self.frame.size.width, self.tableContentView.frame.size.height-10);
        [self.currentTableView reloadData];
    }else
    {
        self.currentChooseCount=(int)self.allArrContainerMutableArr.count-1;
//        NSLog(@"self.currentChooseCount %D scrollViewDidEndDecelerating-1",self.currentChooseCount);
        self.tableContentView.contentSize=CGSizeMake((self.allArrContainerMutableArr.count-1)*ZWSCREEN_WIDTH, 0);
        self.currentTableView.frame=CGRectMake((self.allArrContainerMutableArr.count-1)*self.frame.size.width,0 , self.frame.size.width, self.tableContentView.frame.size.height-10);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != self.titleContentView) return;
        CGFloat offX = scrollView.contentOffset.x;
        if (offX < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    
}
- (void)refreshContenOffsetWithButton:(ZWPickerButton *)btn {
    CGRect frame = btn.frame;//按钮宽度
    CGFloat itemX = frame.origin.x;//按钮起始位置
    CGFloat width = self.titleContentView.frame.size.width-self.titleBtnSpacing;//容器宽度
    CGFloat contentWidth =self.titleContentView.contentSize.width-self.titleBtnSpacing;//容器可滚动范围
    if (itemX > width/2) {
        CGFloat targetX;
        if (itemX+frame.size.width+2*self.titleBtnSpacing<width&&contentWidth<=width) {
            [self.titleContentView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
        {
            if (contentWidth>width) {
                if ((contentWidth-itemX) <= width/2) {
                    targetX = contentWidth - width;
//                    NSLog(@"%f targetX1",targetX);
                } else {
                    targetX = frame.origin.x - width/2 + frame.size.width/2;
//                    NSLog(@"%f targetX2",targetX);
                }
                
                if (targetX + width > contentWidth) {
                    targetX = contentWidth - width;
//                    NSLog(@"%f targetX3",targetX);
                }

                [self.titleContentView setContentOffset:CGPointMake(targetX, 0) animated:YES];
            }else
            {
                [self.titleContentView setContentOffset:CGPointMake(0, 0) animated:YES];
            }

            
        }

    } else {
        [self.titleContentView setContentOffset:CGPointMake(0, 0) animated:YES];
    }

}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:self.titleBarFont};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, self.titleBarheight)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
-(void)updateParentButtonTitleWithIndex:(int)index With:(NSString *)str
{

    self.currentChooseCount=index;
    ZWPickerButton *tmpBtn=self.titleBtnsMutableArr[index];
    self.titleBtnX=self.titleBtnX-[self calculateRowWidth:tmpBtn.titleLabel.text];
    self.titleBtnX=self.titleBtnX+[self calculateRowWidth:str];
    self.titleContentView.contentSize=CGSizeMake(self.titleBtnX+self.titleBtnSpacing, 0);
    [tmpBtn setTitle:str forState:0];
    CGRect frame = tmpBtn.frame;
    frame.size = CGSizeMake([self calculateRowWidth:str], self.titleBarheight-self.sliderViewheight);
    tmpBtn.frame = frame;


}
-(void)setSourceArr:(NSArray *)sourceArr
{
    _sourceArr=sourceArr;
    self.allArrContainerMutableArr=[NSMutableArray arrayWithObject:sourceArr];
}
-(void)setTitleKeyName:(NSString *)titleKeyName
{
    _titleKeyName=titleKeyName;
}
-(void)setSubArrKeyName:(NSString *)subArrKeyName
{
    _subArrKeyName=subArrKeyName;
}



#pragma mark ZWPickerViewDelegate

- (void)setTitleBarheight:(CGFloat)titleBarheight
{
    
    if (titleBarheight>0) {
        _titleBarheight = titleBarheight;
    }else{
        _titleBarheight = 40;}
}

-(void)setTitleBtnSpacing:(CGFloat)titleBtnSpacing
{
    if (titleBtnSpacing>0) {
        _titleBtnSpacing = titleBtnSpacing;
    }else{
        _titleBtnSpacing = 10;}
}

-(void)setSegmentationheight:(CGFloat)segmentationheight
{
    if (segmentationheight>0){
    _segmentationheight = segmentationheight;
    }else{
        _segmentationheight = 0.5;}
}
- (void)setSliderViewheight:(CGFloat)sliderViewheight
{
    if (sliderViewheight > 0){
        _sliderViewheight = sliderViewheight;
    }else{
        _sliderViewheight = 2;}
}

- (void)setTitleBtnWidth:(CGFloat)titleBtnWidth
{
    if (titleBtnWidth>0){
        _titleBtnWidth = titleBtnWidth;
    }else{
        _titleBtnWidth= 50;}
}

-(void)setTitleBarFont:(UIFont *)titleBarFont
{
    if (titleBarFont) {
        _titleBarFont = titleBarFont;
    }else{
       _titleBarFont= [UIFont systemFontOfSize:13];}
}


@end
