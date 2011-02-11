//
//  JDFrontendAppDelegate.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "JDFrontendAppDelegate.h"

#import "JDConnection.h"

@implementation JDFrontendAppDelegate

@synthesize window;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[JDConnection loadConnections];

    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[JDConnection saveConnections];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[JDConnection loadConnections];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[JDConnection saveConnections];
	[JDConnection disconnect];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

