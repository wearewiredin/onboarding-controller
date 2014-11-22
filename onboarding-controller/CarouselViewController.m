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

#import "ChimpKit.h"
#import "SVProgressHUD.h"
#import "UIView+FLKAutoLayout.h"

@interface CarouselViewController () <UIPageViewControllerDelegate, OnboardingViewControllerDelegate>

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
            
            viewController.delegate = self;            
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
    if (viewController.data.type == ViewTypeInfoLast || viewController.data.type == ViewTypeSignupLast) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    self.pendingIndex = viewController.index;
                                                                            
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {

    self.pageControl.currentPage = self.pendingIndex;
    
}


#pragma mark - Onboarding Delegate

- (void)viewController:(OnboardingViewController *)viewController didSelectSubscribeEmail:(NSString *)email {
    [self subscribe:email firstName:nil];
}

- (void)viewControllerDidSelectSkip:(OnboardingViewController *)viewController {
    [self.delegate carouselCompleted];
}

#pragma mark - Subscribe

- (void)subscribe:(NSString *)email firstName:(NSString *)firstName {
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"Subscribing"];
    
    NSArray *mailChimpGroups = nil;
    if (self.carouselDatasource.mailChimpGroup && self.carouselDatasource.mailChimpGroupName) {
        mailChimpGroups = @[@{@"name": self.carouselDatasource.mailChimpGroupName, @"groups": @[self.carouselDatasource.mailChimpGroup]}];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.carouselDatasource.mailChimpListId forKey:@"id"];
    
    NSString *trimmedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [parameters setValue:@{@"email": trimmedEmail} forKey:@"email"];
    
    [parameters setValue:@"false" forKey:@"replace_interests"];
    [parameters setValue:@"true" forKey:@"update_existing"];
    
    BOOL mailChimpDoubleOptIn = NO;
    [parameters setValue:[NSNumber numberWithBool:mailChimpDoubleOptIn] forKey:@"double_optin"];
    
    NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
    if ([firstName length] > 0) {
        [mergeVars setValue:firstName forKey:@"FNAME"];
    }
    
    if (mailChimpGroups) {
        NSArray *groupings = [NSArray arrayWithArray:mailChimpGroups];
        [mergeVars setValue:groupings forKey:@"groupings"];
    }
    
    [parameters setValue:mergeVars forKey:@"merge_vars"];
    
    
    ChimpKit *ck = [ChimpKit sharedKit];
    [ck callApiMethod:@"lists/subscribe" withApiKey:self.carouselDatasource.mailChimpAPIKey params:parameters andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Thank You"];
            [self.delegate carouselCompleted];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Please try again"];
        }
        
    }];
}


@end
