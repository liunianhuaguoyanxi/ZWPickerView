# ZWPickerView
## 一款优雅灵活高性能的选择器(An elegant and flexible  selector which performance is  pretrey good and  supports multi-level menus)
## How to use：
### Import the header file（设置头文件）
    #import "ZWPickerView.h"
### 1.To initialize the ZWTopSelectVcView 
    ZWPickerView *view= [[ZWPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/2)];
    view.sourceArr=  self.cityListsArr;
    view.titleKeyName=@"name";
    view.subArrKeyName=@"childRen";
    view.delegate=self;
    [self.view addSubview:view];
    
    -(void)ZWPickerViewDelegateClickToCloseZWPickerView:(ZWPickerView *)pickerView WithTotalTitleArr:(NSArray *)totalTitleArr withSelectItem:(NSDictionary *)selectItem
    {
           //TO DO Something
    }
### 创作灵感
#### 1.精仿网易严选地址选择器的布局，并优化了如果标题过长会显示不全的体验
#### 2.公司项目延展，需要在后端动态配置内容，原来最多支持五层，现在可以无限延展
### 综上所述
#### 1.根据服务器部署，动态设置层级, 更加灵活。
#### 2.内容动态自适应，提升用户体验，性能不错。
