//
//  AlignedImageView.m
//  onboarding-controller
//
//  Created by Joshua Howland on 11/18/14.
//  Copyright (c) 2014 Wired In LLC. All rights reserved.
//

#import "AlignedImageView.h"

@interface AlignedImageView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AlignedImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _imageView.image = image;
        [_imageView sizeToFit];
        
        self.frame = _imageView.bounds;
    }
    return self;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    CGFloat widthScaleFactor = CGRectGetWidth(self.bounds) / self.image.size.width;
    CGFloat heightScaleFactor = CGRectGetHeight(self.bounds) / self.image.size.height;
    
    CGFloat imageViewXOrigin = 0;
    CGFloat imageViewYOrigin = 0;
    CGFloat imageViewWidth;
    CGFloat imageViewHeight;
    
    
    if (widthScaleFactor > heightScaleFactor) {
        imageViewWidth = self.image.size.width * widthScaleFactor;
        imageViewHeight = self.image.size.height * widthScaleFactor;
    } else {
        imageViewWidth = self.image.size.width * heightScaleFactor;
        imageViewHeight = self.image.size.height * heightScaleFactor;
        imageViewXOrigin = - (imageViewWidth - CGRectGetWidth(self.bounds))/2;
    }
    
    _imageView.frame = CGRectMake(imageViewXOrigin,
                                  imageViewYOrigin,
                                  imageViewWidth,
                                  imageViewHeight);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}


@end
