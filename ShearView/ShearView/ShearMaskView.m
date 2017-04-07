//
//  ShearMaskView.m
//  maskDemo
//
//  Created by yuanyongguo on 17/3/27.
//  Copyright © 2017年 yuanyongguo. All rights reserved.
//

#import "ShearMaskView.h"


@interface ShearMaskView ()

@property(nonatomic,strong) CAShapeLayer * lineLayer;
@property(nonatomic,strong) CAShapeLayer * cornerLayer;

@end

@implementation ShearMaskView

-(CGFloat)cornerLength {
    if(_cornerLength<=0){
        _cornerLength=20;
    }
    return _cornerLength;
   
}

-(CGFloat)cornerDepth {
    if(_cornerDepth<=0){
        _cornerDepth=5;
    }
    return _cornerDepth;
}


-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
     self.lineLayer.path=[self linePath].CGPath;
    self.cornerLayer.path=[self cornerPath].CGPath;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.shearStyle=ShearStyleCornerAnEmbedded;
        
        self.lineLayer =[[CAShapeLayer alloc]init];
        self.lineLayer.strokeColor=[UIColor whiteColor].CGColor;
        self.lineLayer.lineWidth=1/[UIScreen mainScreen].scale;
        self.lineLayer.fillColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
        [self.layer addSublayer:self.lineLayer];
        
        self.cornerLayer=[[CAShapeLayer alloc]init];
        self.cornerLayer.strokeColor=[UIColor colorWithRed:255/255.0 green:20/255.0 blue:147/255.0 alpha:1.0].CGColor;
        self.cornerLayer.lineWidth=self.cornerDepth;
        self.cornerLayer.fillColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
        [self.layer addSublayer:self.cornerLayer];
    
        self.layer.masksToBounds=NO;
    }
    return self;
}

-(UIBezierPath *) linePath {

    CGRect boxRect=self.bounds;
    UIBezierPath * linePath=[UIBezierPath bezierPath];
    if(self.shearStyle==ShearStyleNone){
        return linePath;
    }else if(self.shearStyle==ShearStyleCornerAnEmbedded){
        boxRect=self.bounds;
    }else if(self.shearStyle==ShearStyleCornerEmbeddedLineInside){
        boxRect=CGRectMake(self.cornerDepth,
                           self.cornerDepth,
                           self.frame.size.width-self.cornerDepth*2,
                           self.frame.size.height-self.cornerDepth*2);
    }else if(self.shearStyle==ShearStyleCornerEmbeddedLineOutside){
        boxRect=self.bounds;
    }
    
    CGFloat boxWidth=boxRect.size.width;
    CGFloat boxHeight=boxRect.size.height;

    /* 四条边框 */
    [linePath moveToPoint:boxRect.origin];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width,0)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width, boxRect.origin.y+boxRect.size.height)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x, boxRect.origin.y+boxRect.size.height)];
    [linePath addLineToPoint:boxRect.origin];
    
    
    /* 横竖线 （9宫格） */
    CGFloat itemWidth=boxWidth/3;
    CGFloat itemHeight=boxHeight/3;
    
    [linePath moveToPoint:CGPointMake(boxRect.origin.x+itemWidth, boxRect.origin.y+0)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+itemWidth, boxRect.origin.y+boxHeight)];
    [linePath moveToPoint:CGPointMake(boxRect.origin.x+itemWidth*2, boxRect.origin.y+0)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+itemWidth*2, boxRect.origin.y+boxHeight)];
    
    [linePath moveToPoint:CGPointMake(boxRect.origin.x+0, boxRect.origin.y+itemHeight)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+boxWidth, boxRect.origin.y+itemHeight)];
    [linePath moveToPoint:CGPointMake(boxRect.origin.x+0, boxRect.origin.y+itemHeight*2)];
    [linePath addLineToPoint:CGPointMake(boxRect.origin.x+boxWidth, boxRect.origin.y+itemHeight*2)];
    return  linePath;
}

-(UIBezierPath *) cornerPath {
    
    CGRect boxRect=self.bounds;
    UIBezierPath * cornerPath=[UIBezierPath bezierPath];
    if(self.shearStyle==ShearStyleNone){
        return cornerPath;
    }else if(self.shearStyle==ShearStyleCornerAnEmbedded){
        boxRect=self.bounds;
    }else if(self.shearStyle==ShearStyleCornerEmbeddedLineInside){
        boxRect=CGRectMake(self.cornerDepth, self.cornerDepth, self.bounds.size.width-self.cornerDepth*2, self.bounds.size.height-self.cornerDepth*2);
    }else if(self.shearStyle==ShearStyleCornerEmbeddedLineOutside){
        boxRect=CGRectMake(self.cornerDepth, self.cornerDepth, self.bounds.size.width-self.cornerDepth*2, self.bounds.size.height-self.cornerDepth*2);
    }
    CGFloat depath=self.cornerDepth/2;
    CGFloat length=self.cornerLength;
    
    /* 四个角落 左上角、右上角、右下角、左下角 */

    [cornerPath moveToPoint:CGPointMake(boxRect.origin.x-depath, boxRect.origin.y+length-depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x-depath,boxRect.origin.y-depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x+length-depath, boxRect.origin.y-depath)];
    
    [cornerPath moveToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath-length, boxRect.origin.y-depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath,boxRect.origin.y-depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath, boxRect.origin.y+length-depath)];
    
    [cornerPath moveToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath, boxRect.origin.y+boxRect.size.height+depath-length)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath,boxRect.origin.y+boxRect.size.height+depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x+boxRect.size.width+depath-length,boxRect.origin.y+boxRect.size.height+depath)];
    
    [cornerPath moveToPoint:CGPointMake(boxRect.origin.x+length-depath, boxRect.origin.y+boxRect.size.height+depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x-depath,boxRect.origin.y+boxRect.size.height+depath)];
    [cornerPath addLineToPoint:CGPointMake(boxRect.origin.x-depath, boxRect.origin.y+boxRect.size.height+depath-length)];
    
   
    return  cornerPath;
    
}

@end
