//
//  FMagnifierView.m
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

#define FMV_AnimateDuration 0.08

#define FMV_Scale 1.3

#define FMV_WH 120

#import "FMagnifierView.h"

@interface FMagnifierView ()

@property (nonatomic, strong) FMagnifierView *strongSelf;

@property (nonatomic, weak) CALayer *contentLayer;

@end

@implementation FMagnifierView

+ (instancetype)magnifierView {
    
    FMagnifierView *mv = [[FMagnifierView alloc] init];
    
    mv.strongSelf = mv;
    
    return mv;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) { }
    
    return self;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.adjustPoint = CGPointMake(0, -40);
        self.scale = FMV_Scale;
        
        self.frame = CGRectMake(0, 0, FMV_WH, FMV_WH);
        self.layer.borderWidth = 5;
        self.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.9] CGColor];
        self.layer.cornerRadius = FMV_WH / 2;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;
        
        CALayer *contentLayer = [CALayer layer];
        contentLayer.frame = self.bounds;
        contentLayer.delegate = self;
        contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:contentLayer];
        self.contentLayer = contentLayer;
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    return self;
}

- (void)setAdjustPoint:(CGPoint)adjustPoint {
    
    _adjustPoint = adjustPoint;
    
    [self setTargetPoint:self.targetPoint];
}

- (void)setScale:(CGFloat)scale {
    
    _scale = scale;
    
    [self.contentLayer setNeedsDisplay];
}

- (void)setTargetWindow:(UIView *)targetWindow {
    
    _targetWindow = targetWindow;
    
    [self makeKeyAndVisible];
    
    __weak FMagnifierView *weakSelf = self;
    
    [UIView animateWithDuration:FMV_AnimateDuration animations:^{
        
        weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    [self setTargetPoint:self.targetPoint];
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    
    _targetPoint = targetPoint;
    
    if (self.targetWindow) {
        
        CGPoint center = CGPointMake(targetPoint.x, self.center.y);
        
        if (targetPoint.y > CGRectGetHeight(self.bounds) * 0.5) {
            
            center.y = targetPoint.y -  CGRectGetHeight(self.bounds) / 2;
        }
        
        self.center = CGPointMake(center.x + self.adjustPoint.x, center.y + self.adjustPoint.y);
        
        [self.contentLayer setNeedsDisplay];
    }
}

- (void)remove:(void (^)(void))complete {
    
    __weak FMagnifierView *weakSelf = self;
    
    [UIView animateWithDuration:FMV_AnimateDuration animations:^{
        
        weakSelf.alpha = 0.5;
        
        weakSelf.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        
        weakSelf.strongSelf = nil;
        
        if (complete != nil) { complete(); }
    }];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextTranslateCTM(ctx, FMV_WH / 2, FMV_WH / 2);
    
    CGContextScaleCTM(ctx, self.scale, self.scale);
    
    CGContextTranslateCTM(ctx, -1 * self.targetPoint.x, -1 * self.targetPoint.y);
    
    [self.targetWindow.layer renderInContext:ctx];
}

- (void)dealloc
{
    [self.contentLayer removeFromSuperlayer];
    
    self.contentLayer = nil;
}

@end
