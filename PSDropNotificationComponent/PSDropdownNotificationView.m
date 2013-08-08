//
//  PSDropNotificationView.m
//  QuickDropdownNotificationExample
//
//  Created by Tomasz Kwolek on 07.08.2013.
//  Copyright (c) 2013 Pastez 2013 www.pastez.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PSDropdownNotificationView.h"

@interface PSDropdownNotificationView()

@property (weak,nonatomic) PSDropdownNotificationApperiance *apperiance;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *messageLabel;
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation PSDropdownNotificationView

- (id)initWithFrame:(CGRect)frame andNotificationData:(PSDropdownNotificationData *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        self.apperiance = [_data apperiance];
        
        self.alpha = 0.0;
        self.backgroundColor = _apperiance.backgroundColor;
        
        float dx = _apperiance.horizontalMargin;
        float dy = _apperiance.verticalMargin;
        if (_data.image) {
            self.imageView = [[UIImageView alloc] initWithImage:data.image];
            _imageView.frame = CGRectMake(dx, dy, _apperiance.imageWidth, _data.image.size.height);
            _imageView.contentMode = UIViewContentModeCenter;
            dx += _apperiance.imageWidth + _apperiance.imageHSpacing;
            [self addSubview:_imageView];
        }
        float textsWidth = CGRectGetWidth(self.frame) - dx - _apperiance.horizontalMargin;
        CGSize titleSize = [_data.title sizeWithFont:_apperiance.titleFont constrainedToSize:CGSizeMake(textsWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(dx, dy, titleSize.width, titleSize.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = _apperiance.titleColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = _apperiance.titleFont;
        _titleLabel.text = _data.title;
        [self addSubview:_titleLabel];
        
        dy += titleSize.height + _apperiance.titleVSpacing;
        
        CGSize messageSize = [_data.message sizeWithFont:_apperiance.messageFont constrainedToSize:CGSizeMake(textsWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(dx, dy, messageSize.width, messageSize.height)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = _apperiance.messageColor;
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = _apperiance.messageFont;
        _messageLabel.text = _data.message;
        [self addSubview:_messageLabel];
        
        dy += messageSize.height + _apperiance.verticalMargin;
        
        if (_apperiance.bottomHLineColor) {
            CALayer *bottomHorizontalLine = [CALayer layer];
            bottomHorizontalLine.frame = CGRectMake(0, dy-1, CGRectGetWidth(self.frame), 1);
            bottomHorizontalLine.backgroundColor = _apperiance.bottomHLineColor.CGColor;
            [self.layer addSublayer:bottomHorizontalLine];
        }
        
        CGRect newFrame = self.frame;
        newFrame.size.height = dy;
        self.frame = newFrame;
        
        if (_apperiance.backgroundImage) {
            UIImageView *background = [[UIImageView alloc] initWithImage:_apperiance.backgroundImage];
            background.frame = CGRectMake(0, 0, CGRectGetWidth(newFrame), CGRectGetHeight(newFrame));
            [self insertSubview:background atIndex:0];
        }
        
        if (_apperiance.shadowOpacity > 0) {
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(0.0, 5.0);
            self.layer.shadowRadius = 5;
            self.layer.shadowOpacity = 0.7;
            
            self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            self.layer.shouldRasterize = YES;
        }
    }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hide
{
    [_timer invalidate];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
