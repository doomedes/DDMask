//
//  ShearMaskView.h
//  maskDemo
//
//  Created by yuanyongguo on 17/3/27.
//  Copyright © 2017年 yuanyongguo. All rights reserved.
//

#import <UIKit/UIKit.h>





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
@interface ShearMaskView : UIView


@property(nonatomic,assign) ShearStyle shearStyle;

/* 四个角落的长度 、厚度*/
@property(nonatomic,assign) CGFloat cornerLength;
@property(nonatomic,assign) CGFloat cornerDepth;

@end
