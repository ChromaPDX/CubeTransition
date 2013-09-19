//
//  ViewController.m
//  CubeTransition
//
//  Created by Leif Shackelford on 9/18/13.
//  Copyright (c) 2013 Leif Shackelford. All rights reserved.
//

#import "ViewController.h"
#import "CHCubeTransitionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/3)];
    
    [_picker setDataSource:self];
    [_picker setDelegate:self];
    
    [self.view addSubview:_picker];
   
    
    _CubeViews = [[NSMutableOrderedSet alloc] initWithCapacity:6];
    
    for (int i = 0; i < 6; i++) {
        
        UIView *face = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-150, self.view.bounds.size.height/2.-150, 300, 300)];
        
        face.backgroundColor = [UIColor greenColor];
        
        UILabel *number = [[UILabel alloc] initWithFrame:face.bounds];
        
        number.text = [NSString stringWithFormat:@"%d", i + 1];
        
        number.font = [UIFont systemFontOfSize:100];
        
        number.textAlignment = NSTextAlignmentCenter;
        
        [face addSubview:number];
        
        [_CubeViews addObject:face];
    }
    
    _currentFace = _CubeViews[0];
    [self.view addSubview:_currentFace];

    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [gestureRecognizer setMinimumNumberOfTouches:2];
    
    
    [self.view addGestureRecognizer:gestureRecognizer];

    
}

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%d", row + 1];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _transitionView = [[CHCubeTransitionView alloc] initWithFrame:self.view.bounds];
    lastNumber = row + 1;
    
    UIView *nextFace = _CubeViews[row];
    
    _transitionView = [[CHCubeTransitionView alloc] initWithFrame:_currentFace.frame];
    
    CubeTransitionDirection dir = 0;
    
    while (dir == 0) {
        dir = (rand() % 5) - 2;
    }
    
    
    [self.transitionView beginTransitionFromView:_currentFace toView:nextFace direction:dir];
    
    _currentFace = nextFace;
    
    [self.transitionView completeTransition:.5];
}


#pragma mark GESTURE RECOGNIZER

- (void) handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        
        
        _transitionView = [[CHCubeTransitionView alloc] initWithFrame:_currentFace.frame];
        
        
    }
    
    
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    CGPoint p = [gestureRecognizer translationInView:self.view];
    
    if (!self.transitionView.transitionDirection) {
        
        UIView *nextFace = _CubeViews[lastNumber++ % 6];
        
        if((abs(velocity.x)) > abs(velocity.y)){
            
            
            if (velocity.x > 0) {
                
                [self.transitionView beginTransitionFromView:_currentFace toView:nextFace direction:CubeTransitionDirectionLeft];
                
                NSLog(@"gesture went right");
                
            }
            else
            {
                [self.transitionView beginTransitionFromView:_currentFace toView:nextFace direction:CubeTransitionDirectionRight];
                
                NSLog(@"gesture went left");
            }
        }
        else {
            
            
            
            if (velocity.y > 0) {
                
                [self.transitionView beginTransitionFromView:_currentFace toView:nextFace direction:CubeTransitionDirectionDown];
                
                NSLog(@"gesture went down");
            }
            else
            {
              [self.transitionView beginTransitionFromView:_currentFace toView:nextFace direction:CubeTransitionDirectionUp];
                
                NSLog(@"gesture went Up");
            }
            
            
            
        }
        
       _currentFace = nextFace;
        
    }
    
    if (self.transitionView.transitionDirection == CubeTransitionDirectionDown || self.transitionView.transitionDirection == CubeTransitionDirectionUp) {
        [self.transitionView updateTranstion:p.y / self.view.bounds.size.height];
    }
    
    else if (self.transitionView.transitionDirection == CubeTransitionDirectionLeft || self.transitionView.transitionDirection == CubeTransitionDirectionRight) {
        [self.transitionView updateTranstion:p.x / self.view.bounds.size.width];
    }
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
        if (self.transitionView.transitionDirection == CubeTransitionDirectionDown || self.transitionView.transitionDirection == CubeTransitionDirectionUp) {
            [self.transitionView completeTransition:[gestureRecognizer velocityInView:self.view].y];
        }
        
        else if (self.transitionView.transitionDirection == CubeTransitionDirectionLeft || self.transitionView.transitionDirection == CubeTransitionDirectionRight) {
            [self.transitionView completeTransition:[gestureRecognizer velocityInView:self.view].x];
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
