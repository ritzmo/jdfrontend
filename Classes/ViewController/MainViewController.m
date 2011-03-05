//
//  MainViewController.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "MainViewController.h"

#import "JDConnection.h"

#import "ConfigListController.h"
#import "ConfigViewController.h"
#import "PackageListController.h"
#import "PackageSplitViewController.h"

@interface MainViewController()
- (BOOL)checkConnection;
@end

@implementation MainViewController

- (void)dealloc
{
	[configListController release];

	[super dealloc];
}

- (void)awakeFromNib
{
	self.delegate = self;
	UIViewController *packageListController = nil;

	if(IS_IPAD())
	{
		packageListController = [[PackageSplitViewController alloc] init];
	}
	else
	{
		UIViewController *actualPackageListController = [[PackageListController alloc] init];
		packageListController = [[UINavigationController alloc] initWithRootViewController:actualPackageListController];
		[actualPackageListController release];
	}
	configListController = [[ConfigListController alloc] init];
	UIViewController *configNavController = [[UINavigationController alloc] initWithRootViewController:configListController];

	self.viewControllers = [NSArray arrayWithObjects:packageListController, configNavController, nil];

	[configNavController release];
	[packageListController release];
	self.selectedIndex = 0;
}

#pragma mark -
#pragma mark MainViewController private methods
#pragma mark -

- (BOOL)checkConnection
{
	// isConnected will connect to default host if not connected
	if(![JDConnection isConnected])
	{
		UIAlertView *notification = [[UIAlertView alloc]
									 initWithTitle:NSLocalizedString(@"Error", @"")
									 message:NSLocalizedString(@"You need to configure this application before you can use it.", @"")
									 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[notification show];
		[notification release];

		// dialog (probably) already visible
		if([self.selectedViewController isEqual:[self.viewControllers lastObject]]
		   && [configListController.navigationController.visibleViewController isKindOfClass:[ConfigViewController class]])
		{
			return NO;
		}

		ConfigViewController *targetViewController = [ConfigViewController newConnection];
		targetViewController.mustSave = YES;
		self.selectedViewController = [self.viewControllers lastObject];
		[configListController.navigationController pushViewController: targetViewController animated: YES];
		[self.selectedViewController viewWillAppear:YES];
		[self.selectedViewController viewDidAppear:YES];
		[targetViewController release];
		return NO;
	}
	return YES;
}

#pragma mark UIViewController delegates

- (void)viewWillAppear:(BOOL)animated
{
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	if([self checkConnection])
		[self.selectedViewController viewDidAppear:animated];
}

/* rotation depends on active view */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	UIViewController *cur = self.selectedViewController;
	if(cur == nil)
		return YES;
	else
		return [cur shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark UITabBarController delegates

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	[self.selectedViewController viewWillDisappear:YES];
	[self.selectedViewController viewDidDisappear:YES];

	if(![self checkConnection])
	{
		self.selectedViewController = [self.viewControllers lastObject];
		[self.selectedViewController viewWillAppear:YES];
		[self.selectedViewController viewDidAppear:YES];
		return NO;
	}

	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[viewController viewWillAppear:YES];
	[viewController viewDidAppear:YES];
}

@end
