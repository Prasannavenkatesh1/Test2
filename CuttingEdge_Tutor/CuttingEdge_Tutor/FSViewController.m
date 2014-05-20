//
//  FSViewController.m
//  CuttingEdge_Tutor
//
//  Created by dev15 on 5/19/14.
//  Copyright (c) 2014 dev15. All rights reserved.
//

#import "FSViewController.h"

@interface FSViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong) CAShapeLayer *blurFilterMask;
@property (assign) CGPoint blurFilterOrigin;
@property (assign) CGFloat blurFilterDiameter;
@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self beginBlurMasking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// begin the blur masking operation.
- (void)beginBlurMasking
{
    self.blurFilterOrigin = self.imageView.center;
    self.blurFilterDiameter = MIN(CGRectGetWidth(self.imageView.bounds), CGRectGetHeight(self.imageView.bounds));
    
    CAShapeLayer *blurFilterMask = [CAShapeLayer layer];
    // Disable implicit animations for the blur filter mask's path property.
    blurFilterMask.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"path", nil];
    blurFilterMask.fillColor = [UIColor blackColor].CGColor;
    blurFilterMask.fillRule = kCAFillRuleEvenOdd;
    blurFilterMask.frame = self.imageView.bounds;
    blurFilterMask.opacity = 0.5f;
    self.blurFilterMask = blurFilterMask;
    [self refreshBlurMask];
    [self.imageView.layer addSublayer:blurFilterMask];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.imageView addGestureRecognizer:pinchGesture];
}

// Move the origin of the blur mask to the location of the tap.
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    self.blurFilterOrigin = [sender locationInView:self.imageView];
    [self refreshBlurMask];
}

// Expand and contract the clear region of the blur mask.
- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // Use some combination of sender.scale and sender.velocity to determine the rate at which you want the circle to expand/contract.
    self.blurFilterDiameter += sender.velocity;
    [self refreshBlurMask];
}

// Update the blur mask within the UI.
- (void)refreshBlurMask
{
    CGFloat blurFilterRadius = self.blurFilterDiameter * 0.5f;
    
    CGMutablePathRef blurRegionPath = CGPathCreateMutable();
    CGPathAddRect(blurRegionPath, NULL, self.imageView.bounds);
    CGPathAddEllipseInRect(blurRegionPath, NULL, CGRectMake(self.blurFilterOrigin.x - blurFilterRadius, self.blurFilterOrigin.y - blurFilterRadius, self.blurFilterDiameter, self.blurFilterDiameter));
    
    self.blurFilterMask.path = blurRegionPath;
    
    CGPathRelease(blurRegionPath);
}


@end
