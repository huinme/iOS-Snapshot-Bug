//
//  UIView+RBUtils.m
//  iOS8-Rendering-Bug
//
//  Created by huin on 2014/10/15.
//  Copyright (c) 2014年 yourcompany.com. All rights reserved.
//

#import "UIView+ERBUtils.h"

@implementation UIView (ERBUtils)

- (void)erb_appendDropshadow {
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 3.5f;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (UIImageView *)erb_bugSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0f);

    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UIImageView *)erb_workaround01Snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0f);

    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UIImageView *)erb_workaround02Snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

@end
