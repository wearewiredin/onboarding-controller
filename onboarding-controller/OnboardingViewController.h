//
//  OnboardingViewController.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnboardingViewData;

@interface OnboardingViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

- (void)updateWithData:(OnboardingViewData *)data;

@end
