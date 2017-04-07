# DDMask
###ShearView
**ShearView** 支持在图片区域内剪切操作（图片以UIViewContentModeScaleAspectFit的形式显示）并返回图片的显示区域、剪切的区域

######使用方法：
``` objectivec
DDShearImageView * shearView=[[DDShearImageView alloc]initWithFrame:self.view.bounds];
//shearView.shearImage=[UIImage imageNamed:@"bg.jpg"];
shearView.shearImage=[UIImage imageNamed:@"test.jpeg"];
[self.view addSubview:shearView];
```
######相关属性说明：

``` objectivec
#import <UIKit/UIKit.h>

@interface DDShearImageView : UIView

@property(nonatomic,assign) CGFloat cornerRadius; //上、下、左、右、左上角、左下角、右上角、右下角  扩展区域的点击面积

@property(nonatomic,assign) CGSize  shearMinSize; //最小的剪切区域大小

@property(nonatomic,assign) CGRect  shearReact;   //剪切的区域

@property(nonatomic,strong) UIImage * shearImage; //剪切的图片

@property(nonatomic,assign) CGRect currentImageRect;//图片显示的区域（根据图片、当前view的比例来获取图片显示的真实区域）

@end

```


``` objectivec
typedef NS_OPTIONS(NSUInteger, ShearStyle) {
    
    ShearStyleNone,                         //无任何样式
    ShearStyleCornerAnEmbedded,             //四个角的样式 内嵌在视图外  边框即视图的边
    ShearStyleCornerEmbeddedLineOutside,    //四个角的样式 内嵌在视图内  边框线位于角外
    ShearStyleCornerEmbeddedLineInside,     //四个角的样式 内嵌在视图内  边框线位于角内 (不建议使用这个样式，太丑)
    
};



/*

 自定义剪切视图样式（自己可以重写一个UIView定制想要的样式）
 支持：九宫格划分、边角标示

 */
@interface DDShearMaskView : UIView


@property(nonatomic,assign) ShearStyle shearStyle;

/* 四个角落的长度 、厚度*/
@property(nonatomic,assign) CGFloat cornerLength;
@property(nonatomic,assign) CGFloat cornerDepth;

@end
``` 
######剪切的效果：

![image](https://github.com/doomedes/DDMask/blob/master/README_Images/shear_Rendering1.png)
![image](https://github.com/doomedes/DDMask/blob/master/README_Images/shear_%20Rendering2.png)
