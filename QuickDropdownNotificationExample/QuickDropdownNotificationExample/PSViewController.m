//
//  PSViewController.m
//  QuickDropdownNotificationExample
//
//  Created by Tomasz Kwolek on 07.08.2013.
//  Copyright (c) 2013 Pastez 2013 www.pastez.com. All rights reserved.
//

#import "PSViewController.h"
#import "PSDropdownNotificationCenter.h"

@interface PSViewController ()

@property (weak,nonatomic) PSDropdownNotificationCenter *nCenter;

@end

@implementation PSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.nCenter = [PSDropdownNotificationCenter sharedInstance];
    _nCenter.notificationShowDirection = PSNotificationShowDirectionFromTop;
    _nCenter.maxVisibleNotifications = 3;
    
    UIButton *addNotificationBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addNotificationBt.translatesAutoresizingMaskIntoConstraints = NO;
    [addNotificationBt addTarget:self action:@selector(addNotification:) forControlEvents:UIControlEventTouchUpInside];
    [addNotificationBt setTitle:@"NORMAL" forState:UIControlStateNormal];
    addNotificationBt.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, 40, 50);
    [self.view addSubview:addNotificationBt];
    
    UIButton *addCustomNotificationBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addCustomNotificationBt.translatesAutoresizingMaskIntoConstraints = NO;
    [addCustomNotificationBt addTarget:self action:@selector(addCustomNotification:) forControlEvents:UIControlEventTouchUpInside];
    [addCustomNotificationBt setTitle:@"CUSTOM" forState:UIControlStateNormal];
    addCustomNotificationBt.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 50, 40, 50);
    [self.view addSubview:addCustomNotificationBt];
    
    UIButton *changeDefaultBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeDefaultBt.translatesAutoresizingMaskIntoConstraints = NO;
    [changeDefaultBt addTarget:self action:@selector(changeDefaultSetting:) forControlEvents:UIControlEventTouchUpInside];
    [changeDefaultBt setTitle:@"CHANGE DEFAULT" forState:UIControlStateNormal];
    changeDefaultBt.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 50, 40, 50);
    [self.view addSubview:changeDefaultBt];
    
    UIButton *changeDirectionBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeDirectionBt.translatesAutoresizingMaskIntoConstraints = NO;
    [changeDirectionBt addTarget:self action:@selector(changeDirection:) forControlEvents:UIControlEventTouchUpInside];
    [changeDirectionBt setTitle:@"CHANGE DIRECTION" forState:UIControlStateNormal];
    changeDirectionBt.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 50, 40, 50);
    [self.view addSubview:changeDirectionBt];
    
    NSDictionary *viewsToLayout = NSDictionaryOfVariableBindings(addNotificationBt, addCustomNotificationBt, changeDefaultBt, changeDirectionBt);
    NSDictionary *metics = @{@"btHeight": @40};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[addNotificationBt]|" options:0 metrics:metics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[addCustomNotificationBt]|" options:0 metrics:metics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[changeDefaultBt]|" options:0 metrics:metics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[changeDirectionBt]|" options:0 metrics:metics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[addNotificationBt(btHeight)][addCustomNotificationBt(btHeight)][changeDefaultBt(btHeight)][changeDirectionBt(btHeight)]|"
                                                                      options:0
                                                                      metrics:metics
                                                                        views:viewsToLayout]];
}

- (void)addNotification:(id)sender
{
    PSDropdownNotificationData *data = [[PSDropdownNotificationData alloc] initWithTitle:@"Test"
                                                                         message:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sit amet commodo sapien, vitae fringilla quam. Quisque consectetur dolor vitae auctor adipiscing."];
    data.uniqueIndetifier = 100;
    if (drand48() > 0.5) {
        data.image = [UIImage imageNamed:@"NotificationIcon"];
    }
    
    //display notification via shared object
    [[PSDropdownNotificationCenter sharedInstance] showNotification:data];
}

- (void)addCustomNotification:(id)sender
{
    PSDropdownNotificationData *data = [[PSDropdownNotificationData alloc] initWithTitle:@"Test"
                                                                                 message:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sit amet commodo sapien, vitae fringilla quam. Quisque consectetur dolor vitae auctor adipiscing."];
    float cr = drand48(); float cg = drand48(); float cb = drand48();
    data.apperiance.backgroundColor = [UIColor colorWithRed:cr green:cg blue:cb alpha:1.0];
    data.apperiance.messageColor = [UIColor colorWithRed:1.0-cr green:1.0-cg blue:1.0-cb alpha:1.0];
    data.apperiance.verticalMargin = 5 + drand48() * 7;
    data.apperiance.titleColor = [UIColor whiteColor];
    data.apperiance.backgroundImage = nil;
    data.apperiance.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0+drand48()*8];
    data.apperiance.titleVSpacing = 7 + drand48() * 6;
    data.apperiance.messageFont = [UIFont fontWithName:@"HelveticaNeue" size:8.0+drand48()*5];
    if (drand48() > 0.5) {
        data.image = [UIImage imageNamed:@"NotificationIcon"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:PSNotificationCenterEventShowNotification object:data];
}

- (void)changeDefaultSetting:(id)sender
{
    PSDropdownNotificationCenter.apperiance.shadowOpacity = 0.0;
    PSDropdownNotificationCenter.apperiance.verticalMargin = 15.0;
    PSDropdownNotificationCenter.apperiance.backgroundImage = [[UIImage imageNamed:@"NotificationBg"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:61.0];
    PSDropdownNotificationCenter.apperiance.backgroundColor = [UIColor clearColor];
    PSDropdownNotificationCenter.apperiance.bottomHLineColor = nil;
    PSDropdownNotificationCenter.apperiance.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26.0f];
    PSDropdownNotificationCenter.apperiance.titleVSpacing = 8.0;
    PSDropdownNotificationCenter.apperiance.messageColor = [UIColor whiteColor];
}

- (void)changeDirection:(id)sender
{
    if ( [PSDropdownNotificationCenter sharedInstance].notificationShowDirection == PSNotificationShowDirectionFromTop )
    {
        [PSDropdownNotificationCenter sharedInstance].notificationShowDirection = PSNotificationShowDirectionFromBottom;
    }else
    {
        [PSDropdownNotificationCenter sharedInstance].notificationShowDirection = PSNotificationShowDirectionFromTop;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
