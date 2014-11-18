//
//  OnboardingViewData.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/18/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OnboardingViewData : NSObject

- (id)initWithContainerColor:(UIColor *)containerColor text:(NSString *)text textColor:(UIColor *)textColor image:(UIImage *)image;

@property (nonatomic, strong, readonly) UIColor *containerColor;
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) UIImage *image;

@end
