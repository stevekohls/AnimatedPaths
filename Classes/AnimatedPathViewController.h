//
//  AnimatedPathViewController.h
//  AnimatedPath
//

@interface AnimatedPathViewController : UIViewController

@property (nonatomic, strong) CAShapeLayer *drawingLayer;
@property (nonatomic, strong) CALayer *pencilLayer;

- (IBAction) replayButtonTapped:(id)sender;

@end

