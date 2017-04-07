//
//  ShearImageView.h
//  maskDemo
//
//  Created by yuanyongguo on 17/3/20.
//  Copyright © 2017年 yuanyongguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShearImageView : UIView

@property(nonatomic,assign) CGFloat cornerRadius; //四个角的宽高、左右边的宽、上下边的高

@property(nonatomic,assign) CGSize  shearMinSize; //最小的剪切区域大小

@property(nonatomic,assign) CGRect  shearReact;   //剪切的区域

@property(nonatomic,strong) UIImage * shearImage; //剪切的图片

@end
