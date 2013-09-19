//
//  CHCubeTransitionView.h
//  Chroma
//
//  Created by Leif Shackelford on 7/1/13.
//  Copyright (c) 2013 chroma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCubeTransitionView : UIView <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

typedef enum {
    CubeTransitionDirectionUp = -1,
    CubeTransitionDirectionDown = 1,
    CubeTransitionDirectionLeft = -2,
    CubeTransitionDirectionRight = 2
} CubeTransitionDirection;

#define PERSPECTIVE_LAYER @"PERSPECTIVE_LAYER"
#define IS_ANIMATING @"IS_ANIMATING"

@property (nonatomic, strong) UIView* transitionView1;
@property (nonatomic, strong) UIView* transitionView2;

@property (nonatomic, weak) UIView* view1;
@property (nonatomic, weak) UIView* view2;

@property (nonatomic, strong) CALayer* perspectiveLayer;
@property (nonatomic, strong) CATransformLayer *firstJointLayer;
@property (nonatomic, strong) CATransformLayer *secondJointLayer;

@property int transitionDirection;

- (void)completeTransition:(float) duration;
-(void)completeTransitionWithoutPhysics:(float) duration;

- (void)beginTransitionFromView:(UIView *)view1 toView:(UIView *)view2 direction:(CubeTransitionDirection)direction;
-(void)updateTranstion:(float)location;
-(void)animateTransition:(float)duration;

@property float completion;

// PHYSICS

@property int collisionCount;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior* collisionBehavior;
@property (nonatomic, strong) UIGravityBehavior* gravityBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior* itemProperties;

@end
