//
//  ViewController.m
//  iOS8-Rendering-Bug
//
//  Created by huin on 2014/10/15.
//  Copyright (c) 2014年 yourcompany.com. All rights reserved.
//

#import "ERBViewController.h"

@import QuartzCore;

#import "ERBNavigationController.h"
#import "UIView+ERBUtils.h"

@interface ERBViewController ()

@property (nonatomic, weak, readwrite) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIViewController *slideMenuViewController;

- (IBAction)p_openButtonDidTapped:(id)sender;
- (void)p_presentSlideMenu;
- (UIImageView *)p_createSnapshotWithView:(UIView *)view;

- (void)p_handleSnapshotTapGesture:(UITapGestureRecognizer *)tap;
- (void)p_dismissSlideMenu;

@end

@implementation ERBViewController

//------------------------------------------------------------------------------
#pragma mark - ViewController Life Cycle
//------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (IBAction)p_openButtonDidTapped:(id)sender {
    [self p_presentSlideMenu];
}

- (void)p_presentSlideMenu {
    UIViewController *parent = self.navigationController;
    if ([parent.view viewWithTag:' nvc']) {
        return;
    }

    UIImageView *snapshot = [self p_createSnapshotWithView:parent.view];
    [parent.view addSubview:snapshot];

    NSString *identifier = NSStringFromClass([ERBNavigationController class]);
    ERBNavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    nvc.view.tag = ' nvc';
    [nvc.view erb_appendDropshadow];

    CGRect frame = parent.view.bounds;
    frame.origin.x = CGRectGetWidth([UIScreen mainScreen].bounds);
    nvc.view.frame = frame;
    [parent.view addSubview:nvc.view];

    [parent addChildViewController:nvc];
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = nvc.view.frame;
        frame.origin.x = CGRectGetWidth([UIScreen mainScreen].bounds)/3.0f;
        nvc.view.frame = frame;
    } completion:^(BOOL finished) {
        [nvc didMoveToParentViewController:parent];
        self.slideMenuViewController = nvc;
    }];
}

- (UIImageView *)p_createSnapshotWithView:(UIView *)view {

    UIImageView *snapshot = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            snapshot = [view erb_bugSnapshot];
            break;
        case 1:
            snapshot = [view erb_workaround01Snapshot];
            break;
        case 2:
            snapshot = [view erb_workaround02Snapshot];
            break;
        default:
            NSLog(@"Undefined index was given!!");
            break;
    }

    snapshot.tag = 'spst';
    snapshot.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleSnapshotTapGesture:)];
    [snapshot addGestureRecognizer:tap];

    return snapshot;
}

- (void)p_handleSnapshotTapGesture:(UITapGestureRecognizer *)tap {
    [self p_dismissSlideMenu];
}

- (void)p_dismissSlideMenu {

    [self.slideMenuViewController willMoveToParentViewController:nil];

    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = self.slideMenuViewController.view.frame;
        frame.origin.x = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.slideMenuViewController.view.frame = frame;
    } completion:^(BOOL finished) {

        [self.slideMenuViewController.view removeFromSuperview];
        [self.slideMenuViewController removeFromParentViewController];

        [[self.navigationController.view viewWithTag:'spst'] removeFromSuperview];
    }];
}

@end
