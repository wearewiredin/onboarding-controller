//
//  OnboardingViewController.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnboardingViewData;

@protocol OnboardingViewControllerDelegate;

@interface OnboardingViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong, readonly) OnboardingViewData *data;

@property (nonatomic, assign) id<OnboardingViewControllerDelegate>delegate;

- (void)updateWithData:(OnboardingViewData *)data;

@end

@protocol OnboardingViewControllerDelegate <NSObject>

- (void)viewController:(OnboardingViewController *)viewController didSelectSubscribeEmail:(NSString *)email;

- (void)viewControllerDidSelectSkip:(OnboardingViewController *)viewController;

@end