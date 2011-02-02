//
//  MainViewController.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "MainViewController.h"

#import "PackageListController.h"

@implementation MainViewController

- (void)awakeFromNib
{
	self.delegate = self;

	UIViewController *packageListController = [[PackageListController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:packageListController];
	self.viewControllers = [NSArray arrayWithObject:navController];

	[navController release];
	[packageListController release];
}

#pragma mark UIViewController delegates

- (void)viewWillAppear:(BOOL)animated
{
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.selectedViewController viewDidAppear:animated];
}

/* rotation depends on active view */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark UITabBarController delegates

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	[self.selectedViewController viewWillDisappear:YES];
	[self.selectedViewController viewDidDisappear:YES];

	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[viewController viewWillAppear:YES];
	[viewController viewDidAppear:YES];
}

@end
