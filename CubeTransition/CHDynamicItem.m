//
//  CHDynamicItem.m
//  Chroma
//
//  Created by Leif Shackelford on 7/2/13.
//  Copyright (c) 2013 chroma. All rights reserved.
//

#import "CHDynamicItem.h"
#import "CHCubeTransitionView.h"

@implementation CHDynamicItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setCenter:(CGPoint)p {
    
    [super setCenter:p];
    
    float position = p.y + 1;
    
    float completion = position / self.superview.bounds.size.height;
    

    
    [_delegate updateTranstion:completion];

    
    //NSLog(@"on the move: %f, %f", self.center.x, self.center.y);
    
    //NSLog(@"%f", completion);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
