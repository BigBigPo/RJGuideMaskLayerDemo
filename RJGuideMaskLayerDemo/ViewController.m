//
//  ViewController.m
//  RJGuideMaskLayerDemo
//
//  Created by Po on 2017/3/10.
//  Copyright © 2017年 Po. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *rectangleView;
@property (weak, nonatomic) IBOutlet UIView *circularView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat size = _circularView.frame.size.width;
    [_circularView.layer setCornerRadius:size / 2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addMaskButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addMaskButton];
}

#pragma mark - event
- (void)pressTouchButton:(UIButton *)sender {
    [sender setHidden:YES];
    [sender removeFromSuperview];
}

#pragma mark - getter
- (void)addMaskButton {
    UIButton * touchButton = [[UIButton alloc] init];
    [touchButton setFrame:[UIScreen mainScreen].bounds];
    [touchButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [touchButton addTarget:self action:@selector(pressTouchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchButton];
    
    CGRect rectangleRect = _rectangleView.frame;
    CGRect cirularRect = _circularView.frame;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    //rounded
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rectangleRect cornerRadius:0] bezierPathByReversingPath]] ;
    //arc
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(cirularRect.origin.x + cirularRect.size.width / 2,
                                                                       cirularRect.origin.y + cirularRect.size.height / 2)
                                                    radius:cirularRect.size.width / 2
                                                startAngle:0
                                                  endAngle:M_PI * 2
                                                 clockwise:NO]];
    //create mask layer
    CAShapeLayer *masklayer = [CAShapeLayer layer];
    masklayer.path = path.CGPath;
    [touchButton.layer setMask:masklayer];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CATextLayer * textLayer = [CATextLayer layer];
    [textLayer setFrame:CGRectMake(0, screenBounds.size.height / 2 - 25, screenBounds.size.width, 50)];
    textLayer.string = @"this is a mask layer";
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 16;
    [touchButton.layer addSublayer:textLayer];
}

@end
