//
//  OnboardingViewData.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/18/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeInfo,
    ViewTypeSignupLast,
    ViewTypeInfoLast // This means no signup form
};

@interface OnboardingViewData : NSObject

- (id)initWithContainerColor:(UIColor *)containerColor text:(NSString *)text textColor:(UIColor *)textColor image:(UIImage *)image type:(ViewType)type;

@property (nonatomic, strong, readonly) UIColor *containerColor;
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) UIImage *image;

@property (nonatomic, assign, readonly) ViewType type;

@end
