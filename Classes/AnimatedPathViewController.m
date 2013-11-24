//
//  AnimatedPathViewController.m
//  AnimatedPath
//

#import <QuartzCore/QuartzCore.h>

#import "AnimatedPathViewController.h"

//if YES, draw an ellipse
//if NO, draw a house
//in iOS6, the 2 animations are in sync.
//in iOS7, the 2 animations are out of sync.  How to make them in sync?
#define DRAW_ELLIPSE YES

@implementation AnimatedPathViewController

- (void) setupDrawingLayer
{
    
    CGRect drawingRect = CGRectInset(self.view.bounds, 100.0f, 100.0f);
    
    UIBezierPath *path = nil;
    
    if (DRAW_ELLIPSE) {
        //path = [UIBezierPath bezierPathWithOvalInRect:drawingRect];
        path = [UIBezierPath bezierPathWithRoundedRect:drawingRect cornerRadius:200.0f];
    }
    else {
        
        CGPoint bottomLeft 	= CGPointMake(CGRectGetMinX(drawingRect), CGRectGetMaxY(drawingRect));
        CGPoint topLeft		= CGPointMake(bottomLeft.x, CGRectGetMinY(drawingRect) + CGRectGetHeight(drawingRect) / 3.0f);
        CGPoint bottomRight = CGPointMake(CGRectGetMaxX(drawingRect), CGRectGetMaxY(drawingRect));
        CGPoint topRight	= CGPointMake(bottomRight.x, topLeft.y);
        CGPoint roofTip		= CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect));
        
        path = [UIBezierPath bezierPath];
        
        [path moveToPoint:bottomLeft];
        [path addLineToPoint:topLeft];
        [path addLineToPoint:roofTip];
        [path addLineToPoint:topRight];
        [path addLineToPoint:topLeft];
        [path addLineToPoint:bottomRight];
        [path addLineToPoint:topRight];
        [path addLineToPoint:bottomLeft];
        [path addLineToPoint:bottomRight];
    }
    
    self.drawingLayer = [CAShapeLayer layer];
    self.drawingLayer.frame = self.view.bounds;
    self.drawingLayer.bounds = drawingRect;
    self.drawingLayer.path = path.CGPath;
    self.drawingLayer.strokeColor = [[UIColor blackColor] CGColor];
    self.drawingLayer.fillColor = nil;
    self.drawingLayer.lineWidth = 10.0f;
    self.drawingLayer.lineJoin = kCALineJoinRound;
    self.drawingLayer.lineCap = kCALineJoinRound;
    
    [self.view.layer addSublayer:self.drawingLayer];
    
    UIImage *pencilImage = [UIImage imageNamed:@"pencil.png"]; //@2x retina image is missing, but who cares, this is just an example app.
    self.pencilLayer = [CALayer layer];
    self.pencilLayer.contents = (id)pencilImage.CGImage;
    self.pencilLayer.contentsScale = [UIScreen mainScreen].scale; //e.g. 1.0 (non-retina), 2.0 (retina)
    self.pencilLayer.anchorPoint = CGPointMake(0.0, 1.0); //bottom left corner
    self.pencilLayer.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    
    [self.view.layer addSublayer:self.pencilLayer];
    
    self.drawingLayer.hidden = YES;
    self.pencilLayer.hidden = YES;
}

- (void) startAnimation
{
    
    [self.drawingLayer removeAllAnimations];
    [self.pencilLayer removeAllAnimations];

    self.drawingLayer.hidden = NO;
    self.pencilLayer.hidden = NO;
    
//    CABasicAnimation *drawingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    drawingAnimation.beginTime = CACurrentMediaTime();
//    drawingAnimation.duration = 10.0f;
//    drawingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    drawingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    [self.drawingLayer addAnimation:drawingAnimation forKey:@"strokeEnd"];

//    CAKeyframeAnimation *drawingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
//    drawingAnimation.beginTime = CACurrentMediaTime();
//    drawingAnimation.duration = 10.0f;
//    drawingAnimation.calculationMode = kCAAnimationPaced;
//    drawingAnimation.values = @[@(0.0f), @(1.0f)];
//    drawingAnimation.removedOnCompletion = YES;
//    drawingAnimation.delegate = self;
//    [self.drawingLayer addAnimation:drawingAnimation forKey:@"strokeEnd"];

    // This is almost identical to the code in one of my apps
    // Demonstrates the same iOS 7 bug as displayed with the CAKeyframeAnimation code above.
    CABasicAnimation *drawingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawingAnimation.beginTime = CACurrentMediaTime();
    drawingAnimation.duration = 10.0f;
    drawingAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    drawingAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawingAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    drawingAnimation.fillMode = kCAFillModeForwards;
    drawingAnimation.removedOnCompletion = YES;
    drawingAnimation.delegate = self;
    [self.drawingLayer addAnimation:drawingAnimation forKey:@"strokeEnd"];

    CAKeyframeAnimation *pencilAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pencilAnimation.path = self.drawingLayer.path;
    pencilAnimation.beginTime = drawingAnimation.beginTime;
    pencilAnimation.duration = drawingAnimation.duration;
    pencilAnimation.calculationMode = kCAAnimationPaced;
    //pencilAnimation.delegate = self;
    pencilAnimation.fillMode = kCAFillModeForwards;
    pencilAnimation.removedOnCompletion = YES;
    [self.pencilLayer addAnimation:pencilAnimation forKey:@"position"];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //pencilAnimation stopped
    
    if (flag) {
        //if finished, hide the pencil.
        //otherwise user hit replayButton midway so don't hide the pencil
        self.pencilLayer.hidden = YES;
    }
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self setupDrawingLayer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startAnimation];
}

- (IBAction) replayButtonTapped:(id)sender
{
    [self startAnimation];
}

@end