//
//  CarouselViewController.h
//  onboarding-controller
//
//  Created by Joshua Howland on 11/17/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselDatasource.h"

@interface CarouselViewController : UIViewController

@property (nonatomic, strong) CarouselDatasource *carouselDatasource;

@end
