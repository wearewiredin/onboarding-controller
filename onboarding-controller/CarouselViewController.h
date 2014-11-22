//
//  CarouselViewController.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselDatasource.h"

@protocol CarouselViewControllerDelegate;

@interface CarouselViewController : UIViewController

@property (nonatomic, strong) CarouselDatasource *carouselDatasource;
@property (nonatomic, assign) id<CarouselViewControllerDelegate>delegate;

@end

@protocol CarouselViewControllerDelegate <NSObject>

- (void)carouselCompleted;

@end
