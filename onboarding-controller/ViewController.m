//
//  ViewController.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/18/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "ViewController.h"
#import "CarouselViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController () <CarouselViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CarouselViewController *viewController = [CarouselViewController new];
    viewController.delegate = self;
    
    CarouselDatasource *datasource = [CarouselDatasource new];
    datasource.mailChimpAPIKey = @"";
    datasource.mailChimpListId = @"";
    datasource.mailChimpGroup = @"";
    datasource.mailChimpGroupName = @"";
    
    datasource.viewsDataset = @[
                                [[OnboardingViewData alloc] initWithContainerColor:UIColorFromRGB(0xb41e23) text:@"Take control of your time\nwith the Pomodoro\nTechnique."textColor:[UIColor whiteColor] image:[UIImage imageNamed:@"onboard1"] type:ViewTypeInfo],
                                [[OnboardingViewData alloc] initWithContainerColor:UIColorFromRGB(0x1f8e16) text:@"Track your time with tags\nand tasks. Easily\nreview your productivity."textColor:[UIColor whiteColor] image:[UIImage imageNamed:@"onboard2"] type:ViewTypeInfo],
                                [[OnboardingViewData alloc] initWithContainerColor:UIColorFromRGB(0x1260a8) text:@"Easily set the time you'll\nbefocusing and the time\nyou'll take a break."textColor:[UIColor whiteColor] image:[UIImage imageNamed:@"onboard3"] type:ViewTypeInfo],
                                [[OnboardingViewData alloc] initWithContainerColor:UIColorFromRGB(0x333333) text:@"Use the app to control your\nWired In sign. Let your\ncoworkers know you're busy."textColor:[UIColor whiteColor] image:[UIImage imageNamed:@"onboard4"] type:ViewTypeInfo],
                                [[OnboardingViewData alloc] initWithContainerColor:[UIColor clearColor] text:@"Sign Coming Soon.\nGet notified when they are available."textColor:[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0] image:[UIImage imageNamed:@"onboard5"] type:ViewTypeSignupLast]
                                ];
    
    viewController.carouselDatasource = datasource;

    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.view addSubview:viewController.view];

}

- (void)carouselCompleted {

    
}

@end
