//
//  CarouselViewController.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "CarouselViewController.h"
#import "OnboardingViewData.h"
#import "OnboardingViewController.h"

#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@interface CarouselViewController () <UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger pendingIndex;

@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                             options:nil];
    self.pageViewController.delegate = self;

    if (self.carouselDatasource.viewsDataset.count > 0) {
        
        NSMutableArray *viewControllers = [NSMutableArray new];
        
        for (int i = 0; i < self.carouselDatasource.viewsDataset.count; i++) {
            
            OnboardingViewController *viewController = [OnboardingViewController new];
            viewController.index = i;
            
            OnboardingViewData *data = self.carouselDatasource.viewsDataset[i];
            [viewController updateWithData:data];
            
            [viewControllers addObject:viewController];
        }
        
        self.carouselDatasource.viewControllers = viewControllers;
        self.pageViewController.dataSource = self.carouselDatasource;
        
        [self.pageViewController setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageViewController];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view addSubview:self.pageViewController.view];

    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];

    [self.pageControl constrainWidthToView:self.view predicate:nil];
    [self.pageControl alignCenterXWithView:self.view predicate:nil];
    [self.pageControl alignBottomEdgeWithView:self.view predicate:[@(-15) stringValue]];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {

    OnboardingViewController *viewController = (OnboardingViewController *)pendingViewControllers[0];
    self.pendingIndex = viewController.index;
                                                                            
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {

    self.pageControl.currentPage = self.pendingIndex;
    
}

@end
