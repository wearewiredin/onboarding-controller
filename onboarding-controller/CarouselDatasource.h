//
//  CarouselDatasource.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OnboardingViewData.h"

@interface CarouselDatasource : NSObject <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *viewsDataset;

@end
