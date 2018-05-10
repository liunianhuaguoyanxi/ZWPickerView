//
//  ZWPickerView.h
//  ZWPickerView
//
//  Created by 流年划过颜夕 on 2018/4/18.
//  Copyright © 2018年 liunianhuaguoyanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZWPickerView;
@protocol ZWPickerViewDelegate <NSObject>

@optional

-(void)ZWPickerViewDelegateClickToCloseZWPickerView:(ZWPickerView *)pickerView WithTotalTitleArr:(NSArray *)totalTitleArr withSelectItem:(NSDictionary *)selectItem;
@end

@interface ZWPickerView : UIView
/** SourceArr */
@property (nonatomic, strong) NSArray *sourceArr;

/** ZWPickerViewDelegate */
@property (nonatomic, weak)   id <ZWPickerViewDelegate>delegate;

/** title Key Name in Dictionary of  sourceArr (标题对应主键名)  */
@property (nonatomic, copy)   NSString *titleKeyName;

/** subArr Key Name in Dictionary of  sourceArr (子数组对应主键名)*/
@property (nonatomic, copy)   NSString *subArrKeyName;




- (instancetype)initWithFrame:(CGRect)frame
           withTitleBarheight:(CGFloat)titleBarheigh
          withTitleBtnSpacing:(CGFloat)titleBtnSpacing
       withSegmentationheight:(CGFloat)segmentationheight
         withSliderViewheight:(CGFloat)sliderViewheight
            withTitleBtnWidth:(CGFloat)titleBtnWidth
           withTitleBarheight:(UIFont *)titleBarFont;
@end



