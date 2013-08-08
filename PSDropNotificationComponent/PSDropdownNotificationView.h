//
//  PSDropNotificationView.h
//  QuickDropdownNotificationExample
//
//  Created by Tomasz Kwolek on 07.08.2013.
//  Copyright (c) 2013 Pastez 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSDropdownNotificationCenter.h"

@interface PSDropdownNotificationView : UIView

@property (assign,readonly,nonatomic) PSDropdownNotificationData *data;
@property (strong,nonatomic) NSTimer *timer;

- (id)initWithFrame:(CGRect)frame andNotificationData:(PSDropdownNotificationData *)data;
- (void)show;
- (void)hide;

@end
