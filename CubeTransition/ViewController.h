//
//  ViewController.h
//  CubeTransition
//
//  Created by Leif Shackelford on 9/18/13.
//  Copyright (c) 2013 Leif Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCubeTransitionView;

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

{
    
    int lastNumber;
    
}
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableOrderedSet *CubeViews;
@property (weak, nonatomic) UIView *currentFace;

@property (strong, nonatomic) CHCubeTransitionView* transitionView;

@end
