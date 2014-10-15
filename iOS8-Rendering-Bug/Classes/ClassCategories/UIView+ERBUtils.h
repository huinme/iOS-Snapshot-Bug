//
//  UIView+RBUtils.h
//  iOS8-Rendering-Bug
//
//  Created by huin on 2014/10/15.
//  Copyright (c) 2014年 yourcompany.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ERBUtils)

- (void)erb_appendDropshadow;
- (UIImageView *)erb_bugSnapshot;
- (UIImageView *)erb_workaround01Snapshot;
- (UIImageView *)erb_workaround02Snapshot;

@end
