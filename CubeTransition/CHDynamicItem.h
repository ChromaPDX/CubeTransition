//
//  CHDynamicItem.h
//  Chroma
//
//  Created by Leif Shackelford on 7/2/13.
//  Copyright (c) 2013 chroma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCubeTransitionView;

@interface CHDynamicItem : UIView <UIDynamicItem>

@property (weak) CHCubeTransitionView* delegate;
@end
