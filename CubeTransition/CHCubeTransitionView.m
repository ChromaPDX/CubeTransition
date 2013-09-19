//
//  CHCubeTransitionView.m
//  Chroma
//
//  Created by Leif Shackelford on 7/1/13.
//  Copyright (c) 2013 chroma. All rights reserved.
//

#import "CHCubeTransitionView.h"
#import <QuartzCore/QuartzCore.h>
#import "CHDynamicItem.h"

@implementation CHCubeTransitionView


@synthesize transitionView1, transitionView2;
@synthesize perspectiveLayer, transitionDirection;
@synthesize firstJointLayer, secondJointLayer;
@synthesize collisionCount;
@synthesize animator, gravityBehavior, collisionBehavior, itemProperties;

- (void)beginTransitionFromView:(UIView *)view1 toView:(UIView *)view2 direction:(CubeTransitionDirection)direction {
    
    //
    
    self.view1 = view1;
    self.view2 = view2;


    transitionView1 = [view1 snapshotViewAfterScreenUpdates:NO];
    transitionView2 = [view2 snapshotViewAfterScreenUpdates:YES];
    

    if(view1.superview){
    self.backgroundColor = view1.superview.backgroundColor;
    }
    else {
        self.backgroundColor = [UIColor blackColor];
    }
    
    transitionDirection = direction;
    
    perspectiveLayer = [CALayer layer];
    [perspectiveLayer setName:PERSPECTIVE_LAYER];
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34 = -1.0/800.0;
    
    perspectiveLayer.sublayerTransform = transform;
    perspectiveLayer.frame = self.bounds;
    [self.layer addSublayer:perspectiveLayer];
    
    firstJointLayer = [CATransformLayer layer];
    [firstJointLayer setFrame:transitionView1.bounds];
    [perspectiveLayer addSublayer:firstJointLayer];
    
    [firstJointLayer addSublayer:transitionView1.layer];
    
    switch (direction) {
        case CubeTransitionDirectionDown:
            
            [self setAnchorPointWhileMaintainingPosition:firstJointLayer anchorPoint:CGPointMake(0.5, 0.f)];
            break;
            
        case CubeTransitionDirectionUp:
            [self setAnchorPointWhileMaintainingPosition:firstJointLayer anchorPoint:CGPointMake(0.5, 1.f)];
            
            break;
            
        case CubeTransitionDirectionLeft:
            
            [self setAnchorPointWhileMaintainingPosition:firstJointLayer anchorPoint:CGPointMake(0, .5f)];
            
            break;
            
        case CubeTransitionDirectionRight:
            [self setAnchorPointWhileMaintainingPosition:firstJointLayer anchorPoint:CGPointMake(1., .5f)];
            
            break;
            
            
    }
    
    secondJointLayer = [CATransformLayer layer];
    
    [secondJointLayer setFrame:transitionView2.bounds];
    
    [perspectiveLayer addSublayer:secondJointLayer];
    
    [secondJointLayer addSublayer:transitionView2.layer];
    
    
    
    CGRect frame = secondJointLayer.frame;
    
    switch (direction) {
            
        case CubeTransitionDirectionDown:
            frame.origin.y = firstJointLayer.frame.origin.y - firstJointLayer.frame.size.height;
            frame.origin.x = firstJointLayer.frame.origin.x;
            break;
            
        case CubeTransitionDirectionUp:
            frame.origin.y = firstJointLayer.frame.origin.y + firstJointLayer.frame.size.height;
            frame.origin.x = firstJointLayer.frame.origin.x;
            break;
            
        case CubeTransitionDirectionRight:
            frame.origin.y = firstJointLayer.frame.origin.y;
            frame.origin.x = firstJointLayer.frame.origin.x + firstJointLayer.frame.size.width;
            break;
            
        case CubeTransitionDirectionLeft:
            frame.origin.y = firstJointLayer.frame.origin.y;
            frame.origin.x = firstJointLayer.frame.origin.x - firstJointLayer.frame.size.width;
            break;
            
    }
    
    secondJointLayer.frame = frame;
    
    switch (direction) {
        case CubeTransitionDirectionDown:
            
            [self setAnchorPointWhileMaintainingPosition:secondJointLayer anchorPoint:CGPointMake(0.5, 1.f)];
            
            break;
            
        case CubeTransitionDirectionUp:
            [self setAnchorPointWhileMaintainingPosition:secondJointLayer anchorPoint:CGPointMake(0.5, 0.f)];
            
            break;
            
        case CubeTransitionDirectionLeft:
            
            [self setAnchorPointWhileMaintainingPosition:secondJointLayer anchorPoint:CGPointMake(1, .5f)];
            
            break;
            
        case CubeTransitionDirectionRight:
            [self setAnchorPointWhileMaintainingPosition:secondJointLayer anchorPoint:CGPointMake(0, .5f)];
            
            break;
            
            
    }
    
    [self calculateTransition:0];
    
    if (!view2.superview){
        [view1.superview addSubview:view2];
    }
    
    if (!self.superview){

        [self.view1.superview addSubview:self];
        
    }
    
    
}

- (void)setAnchorPointWhileMaintainingPosition:(CALayer*)layer anchorPoint:(CGPoint)anchorPoint {
    [layer setAnchorPoint:anchorPoint];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - 0.5), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - 0.5))];
}

-(void)updateTranstion:(float)location {

    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self calculateTransition:location];
    
    [CATransaction commit];
    

}

-(void)calculateTransition:(float)location {
    
    self.completion = fabs(location);
    
    double rotation = M_PI/2.;
    
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DIdentity;
    
    switch (transitionDirection) {
        case CubeTransitionDirectionDown:
            
            t = CATransform3DTranslate(t, 0, CGRectGetHeight(transitionView1.frame) * self.completion, 0);
            t = CATransform3DRotate(t, -rotation * self.completion, 1, 0, 0);
            
            t2 = CATransform3DTranslate(t2, 0, CGRectGetHeight(transitionView2.frame) * (self.completion), 0);
            t2 = CATransform3DRotate(t2, rotation * (1. - self.completion), 1, 0, 0);
            break;
            
        case CubeTransitionDirectionUp:
            t = CATransform3DTranslate(t, 0, -CGRectGetHeight(transitionView1.frame) * self.completion, 0);
            t = CATransform3DRotate(t, rotation * self.completion, 1, 0, 0);
            
            t2 = CATransform3DTranslate(t2, 0, -CGRectGetHeight(transitionView2.frame) * (self.completion), 0);
            t2 = CATransform3DRotate(t2, -rotation * (1. - self.completion), 1, 0, 0);
            break;
            
        case CubeTransitionDirectionLeft:
            
            t = CATransform3DTranslate(t, CGRectGetWidth(transitionView1.frame) * self.completion, 0 , 0);
            t = CATransform3DRotate(t, rotation * self.completion, 0, 1, 0);
            
            t2 = CATransform3DTranslate(t2, CGRectGetWidth(transitionView2.frame) * (self.completion),0 , 0);
            t2 = CATransform3DRotate(t2, -rotation * (1. - self.completion), 0, 1, 0);
            
            break;
            
        case CubeTransitionDirectionRight:
            t = CATransform3DTranslate(t, -CGRectGetWidth(transitionView1.frame) * self.completion, 0, 0);
            t = CATransform3DRotate(t, -rotation * self.completion, 0, 1, 0);
            
            t2 = CATransform3DTranslate(t2, -CGRectGetWidth(transitionView2.frame) * (self.completion),0, 0);
            t2 = CATransform3DRotate(t2, rotation * (1. - self.completion), 0, 1, 0);
            break;
            
            
    }
    
    firstJointLayer.sublayerTransform = t;
    secondJointLayer.sublayerTransform = t2;
    
    
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    collisionCount++;
    
    NSLog(@"collision count %d", collisionCount);
    
    if (collisionCount > 2) {
        [animator removeAllBehaviors];
        
        self.animator = Nil;
        
        item = Nil;
        
        [self complete];
        
    }
}

-(void)completeTransitionWithoutPhysics:(float)duration {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    
    
    [CATransaction setCompletionBlock:^{
        
        [self complete];
        
    }];
    
    [self calculateTransition:1.];
    
    
    [CATransaction commit];

    
    
}

- (void)completeTransition:(float)velocity {
    

    
    CHDynamicItem* weight;
    
    if (transitionDirection == CubeTransitionDirectionUp || transitionDirection == CubeTransitionDirectionDown) {
        
    weight = [[CHDynamicItem alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * self.completion, 1, 1)];
        
    }
    else {
    weight = [[CHDynamicItem alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * self.completion, 1, 1)];
    }
    
    [self addSubview:weight];
    
    [weight setHidden:YES];
    
    weight.delegate = self;
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    animator.delegate = self;
    
    gravityBehavior = [[UIGravityBehavior alloc]initWithItems:Nil];
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:Nil];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    
    itemProperties = [[UIDynamicItemBehavior alloc] initWithItems:Nil];
    itemProperties.elasticity = .01;
    itemProperties.friction = 1.;
    itemProperties.resistance = 1.;
    itemProperties.density = 1.;
    
    [animator addBehavior:collisionBehavior];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:itemProperties];
    
    [collisionBehavior addItem:weight];
    [gravityBehavior addItem:weight];
    [itemProperties addItem:weight];

    gravityBehavior.magnitude = 2.0;
    [itemProperties addLinearVelocity:CGPointMake(0, fabs(velocity))forItem:weight];

   
    
}

-(void)complete {
 
    
    if (!self.view2.superview) {
        [self.superview addSubview:self.view2];
    }
    
    [self.view2.superview bringSubviewToFront:self.view2];
    
    
    [self removeFromSuperview];

    
}


-(void)animateTransition:(float)duration {
    

    [self calculateTransition:0.];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    
    
    [CATransaction setCompletionBlock:^{
        
        //[self complete];
        
        
    }];
    
    [self calculateTransition:1.];
    
    
    [CATransaction commit];

}


- (void)cancelCubeTransitionFromView:(UIView *)view1 toView:(UIView *)view2 direction:(CubeTransitionDirection)direction duration:(float) duration {
    
    
}



@end
