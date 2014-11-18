//
//  CarouselDatasource.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "CarouselDatasource.h"

@interface CarouselDatasource ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation CarouselDatasource

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || self.viewControllers.count <= index) {
        return nil;
    }
    return self.viewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    return [self viewControllerAtIndex:(index - 1)];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    return [self viewControllerAtIndex:(index + 1)];
}

@end
