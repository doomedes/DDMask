//
//  ShearImageView.m
//  maskDemo
//
//  Created by yuanyongguo on 17/3/20.
//  Copyright © 2017年 yuanyongguo. All rights reserved.
//

#import "ShearImageView.h"
#import "ShearMaskView.h"

typedef NS_OPTIONS(NSUInteger, PanControlEvent) {
    
    PanControlEventNone,                    //无任何操作
    PanControlEventMove,                    //移动操作
    
    PanControlEventLeftTopStretching,       //左上角拉伸操作
    PanControlEventLeftBottomStretching,    //左下角拉伸操作
    PanControlEventRightTopStretching,      //右上角拉伸操作
    PanControlEventRightButtomStretching,   //右下角拉伸操作
    
    
    PanControlEventLeftStretch,             //向左拉伸操作
    PanControlEventRightStretch,            //向右拉伸操作
    PanControlEventTopStretch,              //向上拉伸操作
    PanControlEventBottomStretch            //向下拉伸操作
    
};


@interface ShearImageView ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIImageView * blurredImageView;
@property(nonatomic,strong) UIImageView * maskImageView;
@property(nonatomic,strong) UIView * mask_View;
@property(nonatomic,strong) ShearMaskView * maskView;

/* 四个角落 */
@property(nonatomic,assign) CGRect leftTopCorner;
@property(nonatomic,assign) CGRect leftBottomCorner;
@property(nonatomic,assign) CGRect rightTopCorner;
@property(nonatomic,assign) CGRect rightBottomCorner;

/* 四条边线 */
@property(nonatomic,assign) CGRect leftStretchArea;
@property(nonatomic,assign) CGRect rightStretchArea;
@property(nonatomic,assign) CGRect topStretchArea;
@property(nonatomic,assign) CGRect bottomStretchArea;

@end

@implementation ShearImageView {
    CGRect originPanFrame;
    PanControlEvent panControlEvent;
    
    CGRect originPinchFrame;
    
}

#pragma mark- View Prorperty Method


/* 上、下、左、右、左上角、左下角、右上角、右下角  扩展区域的点击面积 （暂时由该属性统一控制、也可以改为多个值分别控制） */
-(CGFloat)cornerRadius {
    if(_cornerRadius<=0){
        _cornerRadius=50;
    }
    return _cornerRadius;
}

-(CGSize)shearMinSize {
    if(CGSizeEqualToSize(_shearMinSize, CGSizeZero)){
        _shearMinSize=CGSizeMake(150, 150);
    }
    return _shearMinSize;
}

-(void)setShearReact:(CGRect)shearReact {
    /* 不能设置比最小区域还小的size */
    if(shearReact.size.height<self.shearMinSize.height||shearReact.size.width<self.shearMinSize.width){
        return;
    }
    self.maskView.frame=shearReact;
    self.mask_View.frame=shearReact;
}

-(CGRect)shearReact {
    return self.maskView.frame;
}

-(void)setShearImage:(UIImage *)shearImage {
    _shearImage=shearImage;
    self.blurredImageView.image=_shearImage;
    self.maskImageView.image=_shearImage;
    
}

-(UIImageView *)blurredImageView {
    if(!_blurredImageView){
        _blurredImageView=[[UIImageView alloc]init];
        _blurredImageView.alpha=0.3;
        _blurredImageView.image=self.shearImage;
    }
    return  _blurredImageView;
}

-(UIImageView *)maskImageView {
    if(!_maskImageView){
        _maskImageView=[[UIImageView alloc]init];
        _maskImageView.image=self.shearImage;
    }
    return _maskImageView;
}

-(UIView *)mask_View {
    if(!_mask_View){
        _mask_View=[[UIView alloc]init];
        _mask_View.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return _mask_View;
}

-(UIView *)maskView {
    if(!_maskView){
        _maskView=[[ShearMaskView alloc]init];
        _maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        //_maskView.layer.borderWidth=1;
        //_maskView.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    return _maskView;
}

/* 四个角落 */
-(CGRect)leftTopCorner {
    CGPoint origin= self.maskView.frame.origin;
    return  CGRectMake(origin.x-self.cornerRadius/2, origin.y-self.cornerRadius/2, self.cornerRadius, self.cornerRadius);
}

-(CGRect)leftBottomCorner {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x-self.cornerRadius/2, origin.y+originSize.height-self.cornerRadius/2, self.cornerRadius, self.cornerRadius);
    
}

-(CGRect)rightTopCorner {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x+originSize.width-self.cornerRadius/2, origin.y-self.cornerRadius/2, self.cornerRadius, self.cornerRadius);
    
}

-(CGRect)rightBottomCorner {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x+originSize.width-self.cornerRadius/2, origin.y+originSize.height-self.cornerRadius/2, self.cornerRadius, self.cornerRadius);
}

/* 四条边线 */
-(CGRect)leftStretchArea {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x-self.cornerRadius/2, origin.y+self.cornerRadius/2, self.cornerRadius,originSize.height-self.cornerRadius);
}

-(CGRect)rightStretchArea {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x+originSize.width-self.cornerRadius/2, origin.y+self.cornerRadius/2, self.cornerRadius,originSize.height-self.cornerRadius);
}

-(CGRect)topStretchArea {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x+self.cornerRadius/2, origin.y-self.cornerRadius/2,originSize.width-self.cornerRadius,self.cornerRadius);
}

-(CGRect)bottomStretchArea {
    CGPoint origin= self.maskView.frame.origin;
    CGSize  originSize= self.maskView.frame.size;
    return  CGRectMake(origin.x+self.cornerRadius/2, origin.y+originSize.height-self.cornerRadius/2, originSize.width-self.cornerRadius,self.cornerRadius);
}


#pragma mark- View Method

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if(self){
        [self loadSubViewInfo];
    }
    return self;

}

- (void) loadSubViewInfo {
    
    /* 当前view的设置 */
    self.shearReact=CGRectMake(100, 100, 200, 200);
    self.cornerRadius=100;
    self.backgroundColor=[UIColor whiteColor];
    
    /* 模糊imageView(底图)的设置 */
    self.blurredImageView.frame=self.bounds;
    self.blurredImageView.image=self.shearImage;
    [self addSubview:self.blurredImageView];
    
    /* 剪切的imageView (真是的剪切imageView) */
    self.maskImageView.frame=self.bounds;
    self.maskImageView.image=self.shearImage;
    [self addSubview:self.maskImageView];
    
    /* 设置剪切imageView的 maskView (剪切效果) */
    self.mask_View.frame=self.shearReact;
    self.maskImageView.maskView=self.mask_View;
    
    /* 该View控制剪切mask_View的手势 */
    self.maskView.frame=self.shearReact;
    [self addSubview:self.maskView];
    
    
    /* 
     相关手势
     pangesture （移动＋拉伸 《左上＋左下＋右上＋右下》）
     pinchgesture 手势缩放
     */
    UIPanGestureRecognizer * pangesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePandGesture:)];
    UIPinchGestureRecognizer * pinchgesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchPandGesture:)];
    pangesture.delegate=self;
    pinchgesture.delegate=self;
    pinchgesture.delaysTouchesEnded=NO;
    pangesture.maximumNumberOfTouches=1;
    [self.maskView addGestureRecognizer:pangesture];
    [self.maskView addGestureRecognizer:pinchgesture];
    
    
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    /*
     防止后期多个值控制 扩展区域 
    （现在可以直接扩大maskview的frame进行判断  ）
     CGRectMake(self.maskView.frame.origin.x-self.cornerRadius/2,
                self.maskView.frame.origin.y-self.cornerRadius/2,
                self.maskView.frame.size.width+self.cornerRadius,
                self.maskView.frame.size.height+self.cornerRadius)
     */
   
    if(CGRectContainsPoint(self.leftTopCorner, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.leftBottomCorner, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.rightTopCorner, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.rightBottomCorner, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.leftStretchArea, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.rightStretchArea, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.topStretchArea, point)){
        return self.maskView;
    }else if(CGRectContainsPoint(self.bottomStretchArea, point)){
        return self.maskView;
    }
    
    return [super hitTest:point withEvent:event];
    
}


#pragma  mark- Gesture Action

/*
 移动＋角落拉伸+边拉伸操作
 */
-(void) handlePandGesture:(UIPanGestureRecognizer *) gesture {
    
    /* 当前手势操作类型 */
    if(gesture.state==UIGestureRecognizerStateBegan){
        originPanFrame= self.maskView.frame;
        CGPoint touchPoint=[gesture locationInView:self];
        if(CGRectContainsPoint(self.leftTopCorner, touchPoint)){
            panControlEvent=PanControlEventLeftTopStretching;
        }else  if(CGRectContainsPoint(self.rightTopCorner, touchPoint)){
            panControlEvent=PanControlEventRightTopStretching;
        }else  if(CGRectContainsPoint(self.rightBottomCorner, touchPoint)){
            panControlEvent=PanControlEventRightButtomStretching;
        }else  if(CGRectContainsPoint(self.leftBottomCorner, touchPoint)){
            panControlEvent=PanControlEventLeftBottomStretching;
        }else  if(CGRectContainsPoint(self.leftStretchArea, touchPoint)){
            panControlEvent=PanControlEventLeftStretch;
        }else  if(CGRectContainsPoint(self.rightStretchArea, touchPoint)){
            panControlEvent=PanControlEventRightStretch;
        }else  if(CGRectContainsPoint(self.topStretchArea, touchPoint)){
            panControlEvent=PanControlEventTopStretch;
        }else  if(CGRectContainsPoint(self.bottomStretchArea, touchPoint)){
            panControlEvent=PanControlEventBottomStretch;
        }else if(CGRectContainsPoint(self.maskView.frame, touchPoint)){
            panControlEvent=PanControlEventMove;
        }else{
            panControlEvent=PanControlEventNone;
        }
    }
    
    if(gesture.state==UIGestureRecognizerStateChanged){
        
        CGPoint  point= [gesture translationInView:self.maskView];
        CGRect currentFrame= self.maskView.frame;
        
        if(panControlEvent==PanControlEventMove){
            CGFloat x = currentFrame.origin.x + point.x;
            CGFloat y = currentFrame.origin.y + point.y;
            if(x<0){
                x=0;
            }else if(x>=self.frame.size.width-currentFrame.size.width){
                x=self.frame.size.width-currentFrame.size.width;
            }
            if(y<0){
                y=0;
            }else if(y>=self.frame.size.height-currentFrame.size.height){
                y=self.frame.size.height-currentFrame.size.height;
            }
            currentFrame.origin=CGPointMake(x, y);
            
        }else if(panControlEvent==PanControlEventLeftTopStretching){
            
             /* 控制 x、y、width、height  限制相应数据 */
            
            CGFloat disx=point.x;
            CGFloat disy=point.y;
            if(point.x<0 && (currentFrame.origin.x + point.x)<0){
                disx=-currentFrame.origin.x;
            }else if(point.x>0 && (currentFrame.size.width-point.x)<self.shearMinSize.width){
                disx=currentFrame.size.width-self.shearMinSize.width;
            }
            
            if(point.y<0 && (currentFrame.origin.y + point.y)<0){
                disy=-currentFrame.origin.y;
            }else if(point.y>0 && (currentFrame.size.height-point.y)<self.shearMinSize.height){
                disy=currentFrame.size.height-self.shearMinSize.height;
            }
            
            CGFloat x=currentFrame.origin.x+disx;
            CGFloat y=currentFrame.origin.y+disy;
            CGFloat w=currentFrame.size.width-disx;
            CGFloat h=currentFrame.size.height-disy;
            currentFrame=CGRectMake(x, y, w, h);
            
        }else  if(panControlEvent==PanControlEventRightTopStretching){
            
            /* 控制 y、width、height  限制相应数据 */
            
            CGFloat disw=point.x;
            CGFloat disy=point.y;
            if(point.x<0 && (currentFrame.size.width + point.x)<self.shearMinSize.width){
                disw=self.shearMinSize.width-currentFrame.size.width;
            }if(point.x>0 && (currentFrame.size.width + point.x)>(self.frame.size.width-currentFrame.origin.x)){
                disw=(self.frame.size.width-currentFrame.origin.x)-currentFrame.size.width;
            }
            
            if(point.y<0 && (currentFrame.origin.y + point.y)<0){
                disy=-currentFrame.origin.y;
            }else if(point.y>0 && (currentFrame.size.height-point.y)<self.shearMinSize.height){
                disy=currentFrame.size.height-self.shearMinSize.height;
            }
            
            CGFloat x=currentFrame.origin.x;
            CGFloat y=currentFrame.origin.y+disy;
            CGFloat w=currentFrame.size.width+disw;
            CGFloat h=currentFrame.size.height-disy;
            currentFrame=CGRectMake(x, y, w, h);
            
        }else  if(panControlEvent==PanControlEventRightButtomStretching){
            
             /* 控制 width、height  限制相应数据 */
            CGFloat disw = point.x;
            CGFloat dish = point.y;
            if(point.x<0 && (currentFrame.size.width + point.x)<self.shearMinSize.width){
                disw=self.shearMinSize.width-currentFrame.size.width;
            }if(point.x>0 && (currentFrame.size.width + point.x)>(self.frame.size.width-self.maskView.frame.origin.x)){
                disw=(self.frame.size.width-currentFrame.origin.x)-currentFrame.size.width;
            }
            
            
            if(point.y<0 && (currentFrame.size.height+point.y)<self.shearMinSize.height){
                dish=self.shearMinSize.height-currentFrame.size.height;
            }else if(point.y>0 && (currentFrame.size.height+point.y) >(self.frame.size.height-currentFrame.origin.y)){
                dish=self.frame.size.height-currentFrame.origin.y-currentFrame.size.height;
            }
            CGFloat x=currentFrame.origin.x;
            CGFloat y=currentFrame.origin.y;
            CGFloat w=currentFrame.size.width+disw;
            CGFloat h=currentFrame.size.height+dish;
            currentFrame=CGRectMake(x, y, w, h);
            
            
        }else  if(panControlEvent==PanControlEventLeftBottomStretching){
            
             /* 控制 x、width、height  限制相应数据 */
            CGFloat disx =point.x;
            CGFloat dish =point.y;
            if(point.x<0 && (currentFrame.origin.x + point.x)<0){
                disx=-currentFrame.origin.x;
            }else if(point.x>0 && (currentFrame.size.width-point.x)<self.shearMinSize.width){
                disx=currentFrame.size.width-self.shearMinSize.width;
            }
            
            
            if(point.y<0 && (currentFrame.size.height+point.y)<self.shearMinSize.height){
                dish=self.shearMinSize.height-currentFrame.size.height;
            }else if(point.y>0 && (currentFrame.size.height+point.y) >(self.frame.size.height-currentFrame.origin.y)){
                dish=self.frame.size.height-currentFrame.origin.y-currentFrame.size.height;
            }
            CGFloat x=currentFrame.origin.x+disx;
            CGFloat y=currentFrame.origin.y;
            CGFloat w=currentFrame.size.width-disx;
            CGFloat h=currentFrame.size.height+dish;
            currentFrame=CGRectMake(x, y, w, h);
            
        }else if(panControlEvent==PanControlEventLeftStretch){
            
             /* 控制 x 、width  限制相应数据 */
            
            CGFloat disx =point.x;
            if(point.x<0 && (currentFrame.origin.x + point.x)<0){
                disx=-currentFrame.origin.x;
            }else if(point.x>0 && (currentFrame.size.width-point.x)<self.shearMinSize.width){
                disx=currentFrame.size.width-self.shearMinSize.width;
            }
            
            CGFloat x=currentFrame.origin.x+disx;
            CGFloat y=currentFrame.origin.y;
            CGFloat w=currentFrame.size.width-disx;
            CGFloat h=currentFrame.size.height;
            currentFrame=CGRectMake(x, y, w, h);
            
            
        }else if(panControlEvent==PanControlEventRightStretch){
            
            /* 控制 width  限制相应数据 */
            
            CGFloat disw=point.x;
            if(point.x<0 && (currentFrame.size.width + point.x)<self.shearMinSize.width){
                disw=self.shearMinSize.width-currentFrame.size.width;
            }if(point.x>0 && (currentFrame.size.width + point.x)>(self.frame.size.width-currentFrame.origin.x)){
                disw=(self.frame.size.width-currentFrame.origin.x)-currentFrame.size.width;
            }

            CGFloat x=currentFrame.origin.x;
            CGFloat y=currentFrame.origin.y;
            CGFloat w=currentFrame.size.width+disw;
            CGFloat h=currentFrame.size.height;
            currentFrame=CGRectMake(x, y, w, h);
            
        }else if(panControlEvent==PanControlEventTopStretch){
            
            /* 控制 y、height  限制相应数据 */
            
            CGFloat disy=point.y;
            if(point.y<0 && (currentFrame.origin.y + point.y)<0){
                disy=-currentFrame.origin.y;
            }else if(point.y>0 && (currentFrame.size.height-point.y)<self.shearMinSize.height){
                disy=currentFrame.size.height-self.shearMinSize.height;
            }
            
            CGFloat x=currentFrame.origin.x;
            CGFloat y=currentFrame.origin.y+disy;
            CGFloat w=currentFrame.size.width;
            CGFloat h=currentFrame.size.height-disy;
            currentFrame=CGRectMake(x, y, w, h);
            
            
        }else if(panControlEvent==PanControlEventBottomStretch){

            /* 控制 height  限制相应数据 */

            CGFloat dish =point.y;
            if(point.y<0 && (currentFrame.size.height+point.y)<self.shearMinSize.height){
                dish=self.shearMinSize.height-currentFrame.size.height;
            }else if(point.y>0 && (currentFrame.size.height+point.y) >(self.frame.size.height-currentFrame.origin.y)){
                dish=self.frame.size.height-currentFrame.origin.y-currentFrame.size.height;
            }
            CGFloat x=currentFrame.origin.x;
            CGFloat y=currentFrame.origin.y;
            CGFloat w=currentFrame.size.width;
            CGFloat h=currentFrame.size.height+dish;
            currentFrame=CGRectMake(x, y, w, h);
        }
        
        self.maskView.frame=currentFrame;
        [gesture setTranslation:CGPointMake(0, 0) inView:self.maskView];
        self.mask_View.frame=self.maskView.frame;
    }
    
    if(gesture.state==UIGestureRecognizerStateEnded||gesture.state==UIGestureRecognizerStateCancelled){
        
    }
    
}


/*
 手势缩放操作
 */
-(void) pinchPandGesture:(UIPinchGestureRecognizer *) gesture {
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        originPinchFrame=self.maskView.frame;
    }
    
    if(gesture.state==UIGestureRecognizerStateChanged) {
        
        CGFloat nwidth=originPinchFrame.size.width*gesture.scale;
        CGFloat nheight=originPinchFrame.size.height*gesture.scale;
        
        /* 缩小后宽度、高度小于最小size */
        if(nwidth<=self.shearMinSize.width){
            nwidth=self.shearMinSize.width;
        }
        if(nheight<=self.shearMinSize.height){
            nheight=self.shearMinSize.height;
        }
        
        
        CGRect newFrame=CGRectMake(originPinchFrame.origin.x+originPinchFrame.size.width/2-nwidth/2,
                                   originPinchFrame.origin.y+originPinchFrame.size.height/2-nheight/2,
                                   nwidth,
                                   nheight);
        
        if(newFrame.origin.x<=0){
            newFrame.origin.x=0;
        }
        
        if(newFrame.origin.y<=0){
            newFrame.origin.y=0;
        }
        
        /* 宽>高 */
        if(originPinchFrame.size.width<=originPinchFrame.size.height){
            if(newFrame.size.width>=self.bounds.size.width){
                newFrame.size.width=self.bounds.size.width;
                newFrame.size.height=newFrame.size.width/originPinchFrame.size.width*originPinchFrame.size.height;
            }
        }else{
            if(newFrame.size.height>=self.bounds.size.height){
                newFrame.size.height=self.bounds.size.height;
                newFrame.size.width=newFrame.size.height/originPinchFrame.size.height*originPinchFrame.size.width;
            }
        }
        /* 放大后宽度、高度大于当前所在的view */
        if((newFrame.size.width+newFrame.origin.x)>=self.bounds.size.width){
            newFrame.origin.x=self.bounds.size.width-newFrame.size.width;
        }
        if((newFrame.size.height+newFrame.origin.y)>=self.bounds.size.height){
            newFrame.origin.y=self.bounds.size.height-newFrame.size.height;
        }
        
   
    
        self.maskView.frame=newFrame;
        self.mask_View.frame=self.maskView.frame;
    }
    
    if(gesture.state==UIGestureRecognizerStateEnded||gesture.state==UIGestureRecognizerStateCancelled){
        
    }
    
}


@end


