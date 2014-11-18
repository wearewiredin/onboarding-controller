//
//  OnboardingViewData.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/18/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "OnboardingViewData.h"

@interface OnboardingViewData ()

@property (nonatomic, strong) UIColor *containerColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) ViewType type;


@end

@implementation OnboardingViewData

- (id)initWithContainerColor:(UIColor *)containerColor text:(NSString *)text textColor:(UIColor *)textColor image:(UIImage *)image type:(ViewType)type{

    self = [super init];
    if (self) {
        self.containerColor = containerColor;
        self.textColor = textColor;
        self.text = text;
        self.image = image;
        self.type = type;
    }
    return self;
}

@end
