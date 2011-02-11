//
//  ConfigViewController.m
//  JDFrontend
//
//  Created by Moritz Venn on 10.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "ConfigViewController.h"

#import "JDConnection.h"
#import "Constants.h"

#import "DisplayCell.h"

/*!
 @brief Private functions of ConfigViewController.
 */
@interface ConfigViewController()
/*!
 @brief Create standardized UITextField.
 
 @return UITextField instance.
 */
- (UITextField *)create_TextField;

/*!
 @brief Create standardized UIButton.
 
 @param imageName Name of Image to illustrate button with.
 @param action Selector to call on UIControlEventTouchUpInside.
 @return UIButton instance.
 */
- (UIButton *)create_Button: (NSString *)imageName: (SEL)action;

/*!
 @brief Selector to call when _makeDefaultButton was pressed.
 
 @param sender Unused instance of sender.
 */
- (void)makeDefault: (id)sender;

/*!
 @brief Selector to call when _connectButton was pressed.
 
 @param sender Unused instance of sender.
 */
- (void)doConnect: (id)sender;

/*!
 @brief stop editing
 @param sender ui element
 */
- (void)cancelEdit: (id)sender;
@end

/*!
 @brief Keyboard offset.
 The amount of vertical shift upwards to keep the text field in view as the keyboard appears.
 */
#define kOFFSET_FOR_KEYBOARD                                   150

/*! @brief The duration of the animation for the view shift. */
#define kVerticalOffsetAnimationDuration               (CGFloat)0.30


@implementation ConfigViewController

@synthesize connectionIndex = _connectionIndex;
@synthesize hostname = _hostname;
@synthesize makeDefaultButton = _makeDefaultButton;
@synthesize connectButton = _connectButton;
@synthesize mustSave = _mustSave;

/* initialize */
- (id)init
{
	if((self = [super init]))
	{
		self.title = NSLocalizedString(@"Configuration", @"Default title of ConfigViewController");
		_mustSave = NO;
	}
	return self;
}

/* initiate ConfigViewController with given connection and index */
+ (ConfigViewController *)withHost: (NSString *)newHost: (NSInteger)atIndex
{
	ConfigViewController *configViewController = [[ConfigViewController alloc] init];
	configViewController.hostname = newHost;
	configViewController.connectionIndex = atIndex;

	return [configViewController autorelease];
}

/* initiate ConfigViewController with new connection */
+ (ConfigViewController *)newConnection
{
	ConfigViewController *configViewController = [[ConfigViewController alloc] init];
	configViewController.hostname = @"";
	configViewController.connectionIndex = -1;

	return configViewController;
}

/* dealloc */
- (void)dealloc
{
	[_hostname release];
	[_remoteAddressTextField release];
	[_makeDefaultButton release];
	[_connectButton release];
	//[_sslSwitch release];

	[super dealloc];
}

/* create a textfield */
- (UITextField *)create_TextField
{
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:CGRectZero];

	returnTextField.leftView = nil;
	returnTextField.leftViewMode = UITextFieldViewModeNever;
	returnTextField.borderStyle = UITextBorderStyleRoundedRect;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:kTextFieldFontSize];
    returnTextField.backgroundColor = [UIColor whiteColor];
	// no auto correction support
	returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	returnTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	returnTextField.keyboardType = UIKeyboardTypeDefault;
	returnTextField.returnKeyType = UIReturnKeyDone;

	// has a clear 'x' button to the right
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

	return [returnTextField autorelease];
}

/* create a button */
- (UIButton *)create_Button: (NSString *)imageName: (SEL)action
{
	const CGRect frame = CGRectMake(0, 0, kUIRowHeight, kUIRowHeight);
	UIButton *button = [[UIButton alloc] initWithFrame: frame];
	UIImage *image = [UIImage imageNamed: imageName];
	[button setImage: image forState: UIControlStateNormal];
	[button addTarget: self action: action
		forControlEvents: UIControlEventTouchUpInside];

	return [button autorelease];
}

/* layout */
- (void)loadView
{
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// create and configure the table view
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;

	// setup our content view so that it auto-rotates along with the UViewController
	tableView.autoresizesSubviews = YES;
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	self.view = tableView;
	[tableView release];

	// Remote Address
	_remoteAddressTextField = [[self create_TextField] retain];
	_remoteAddressTextField.placeholder = NSLocalizedString(@"<hostname, e.g. 192.168.0.1>", @"");
	_remoteAddressTextField.text = [_hostname copy];
	_remoteAddressTextField.keyboardType = UIKeyboardTypeURL;

	// SSL
	//_sslSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(0, 0, kSwitchButtonWidth, kSwitchButtonHeight)];
	//_sslSwitch.on = [[_connection objectForKey: kSSL] boolValue];

	// Connect Button
	self.connectButton = [self create_Button: @"network-wired.png": @selector(doConnect:)];
	_connectButton.enabled = YES;

	// "Make Default" Button
	self.makeDefaultButton = [self create_Button: @"emblem-favorite.png": @selector(makeDefault:)];
	_makeDefaultButton.enabled = YES;

	[self setEditing:YES animated:NO];
}

/* (un)set editing */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	if(!editing)
	{
		if(_shouldSave)
		{
			if(!_remoteAddressTextField.text.length)
			{
				UIAlertView *notification = [[UIAlertView alloc]
											 initWithTitle:NSLocalizedString(@"Error", @"")
											 message:NSLocalizedString(@"A connection needs a hostname.", @"No hostname entered in ConfigView.")
											 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[notification show];
				[notification release];
				return;
			}

			NSMutableArray *connections = [JDConnection getConnections];
			if(_connectionIndex == -1)
			{
				[(UITableView *)self.view beginUpdates];
				_connectionIndex = [connections count];
				NSString *hostname = [_remoteAddressTextField.text copy];
				[connections addObject:hostname];
				[hostname release];

				// FIXME: ugly!
				if(_connectionIndex != [[NSUserDefaults standardUserDefaults] integerForKey:kActiveConnection] || _connectionIndex != [JDConnection getConnectedId])
					[(UITableView *)self.view insertSections:[NSIndexSet indexSetWithIndex:3]
											withRowAnimation:UITableViewRowAnimationFade];
				[(UITableView *)self.view endUpdates];
			}
			else
			{
				NSString *hostname = [_remoteAddressTextField.text copy];
				[connections replaceObjectAtIndex:_connectionIndex withObject:hostname];
				[hostname release];

				// Reconnect because changes won't be applied otherwise
				if(_connectionIndex == [JDConnection getConnectedId])
				{
					[JDConnection connectTo: _connectionIndex];
				}
			}

		}

		[self.navigationItem setLeftBarButtonItem: nil animated: YES];

		[_remoteAddressCell stopEditing];
	}
	else
	{
		_shouldSave = YES;
		UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelEdit:)];
		[self.navigationItem setLeftBarButtonItem: cancelButtonItem animated: YES];
		[cancelButtonItem release];
	}

	[super setEditing: editing animated: animated];

	/*_makeDefaultButton.enabled = editing;
	 _connectButton.enabled = editing;*/
}

/* cancel and close */
- (void)cancelEdit: (id)sender
{
	if(_mustSave && ![[JDConnection getConnections] count])
	{
		UIAlertView *notification = [[UIAlertView alloc]
									initWithTitle:NSLocalizedString(@"Error", @"")
									message:NSLocalizedString(@"You have to enter connection details to use this application.", @"")
									delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[notification show];
		[notification release];
	}
	else
	{
		_shouldSave = NO;
		[self setEditing: NO animated: YES];
		[self.navigationController popViewControllerAnimated: YES];
	}
}

/* "make default" button pressed */
- (void)makeDefault: (id)sender
{
	NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *activeConnection = [NSNumber numberWithInteger: _connectionIndex];

	if(![JDConnection connectTo: _connectionIndex])
	{
		// error connecting... what now?
		UIAlertView *notification = [[UIAlertView alloc]
									 initWithTitle:NSLocalizedString(@"Error", @"")
									 message:NSLocalizedString(@"Unable to connect to host.\nPlease restart the application.", @"")
									 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[notification show];
		[notification release];
		return;
	}
	[stdDefaults setObject: activeConnection forKey: kActiveConnection];

	[(UITableView *)self.view beginUpdates];
	[(UITableView *)self.view deleteSections: [NSIndexSet indexSetWithIndex: 3]
								withRowAnimation: UITableViewRowAnimationFade];
	[(UITableView *)self.view endUpdates];
}

/* "connect" button pressed */
- (void)doConnect: (id)sender
{
	NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];

	if(![JDConnection connectTo: _connectionIndex])
	{
		// error connecting... what now?
		UIAlertView *notification = [[UIAlertView alloc]
									 initWithTitle:NSLocalizedString(@"Error", @"")
									 message:NSLocalizedString(@"Unable to connect to host.\nPlease restart the application.", @"")
									 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[notification show];
		[notification release];
		return;
	}

	[(UITableView *)self.view beginUpdates];
	if(_connectionIndex == [stdDefaults integerForKey: kActiveConnection])
		[(UITableView *)self.view deleteSections: [NSIndexSet indexSetWithIndex: 3]
									withRowAnimation: UITableViewRowAnimationFade];
	else
		[(UITableView *)self.view
				deleteRowsAtIndexPaths: [NSArray arrayWithObject:
											[NSIndexPath indexPathForRow:0 inSection:3]]
				withRowAnimation: UITableViewRowAnimationFade];
	[(UITableView *)self.view endUpdates];
}

/* rotate with device */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - UITableView delegates

/* no editing style for any cell */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

/* number of sections */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(	_connectionIndex == -1
		|| (_connectionIndex == [[NSUserDefaults standardUserDefaults] integerForKey: kActiveConnection] && _connectionIndex == [JDConnection getConnectedId]))
		return 1;
	return 2;
}

/* title for sections */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return NSLocalizedString(@"Remote Host", @"");
		default:
			return nil;
	}
}

/* rows per section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return 1;
		case 1:
			if(_connectionIndex == [[NSUserDefaults standardUserDefaults] integerForKey: kActiveConnection]
			   || _connectionIndex == [JDConnection getConnectedId])
				return 1;
			return 2;
		default: break;
	}
	return 0;
}

// to determine specific row height for each cell, override this. 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kUIRowHeight;
}

/* determine which UITableViewCell to be used on a given row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	UITableViewCell *sourceCell = nil;

	// we are creating a new cell, setup its attributes
	switch(section)
	{
		case 0:
			sourceCell = [tableView dequeueReusableCellWithIdentifier: kCellTextField_ID];
			if(sourceCell == nil)
				sourceCell = [[[CellTextField alloc] initWithFrame: CGRectZero reuseIdentifier: kCellTextField_ID] autorelease];
			((CellTextField *)sourceCell).delegate = self; // so we can detect when cell editing starts
			((CellTextField *)sourceCell).view = _remoteAddressTextField;
			_remoteAddressCell = (CellTextField *)sourceCell;
			break;
		case 1:
			sourceCell = [tableView dequeueReusableCellWithIdentifier: kDisplayCell_ID];
			if(sourceCell == nil)
				sourceCell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];

			if(_connectionIndex == [JDConnection getConnectedId])
				row++;

			switch(row)
			{
				case 0:
					((DisplayCell *)sourceCell).nameLabel.text = NSLocalizedString(@"Connect", @"");
					((DisplayCell *)sourceCell).view = _connectButton;
					break;
				case 1:
					((DisplayCell *)sourceCell).nameLabel.text = NSLocalizedString(@"Make Default", @"");
					((DisplayCell *)sourceCell).view = _makeDefaultButton;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}

	return sourceCell;
}

/* select row */
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = indexPath.row;
	if(indexPath.section == 3)
	{
		if(_connectionIndex == [JDConnection getConnectedId])
			++row;

		if(row == 0)
			[self doConnect: nil];
		else
			[self makeDefault: nil];
	}
    return nil;
}

#pragma mark -
#pragma mark <EditableTableViewCellDelegate> Methods and editing management

/* stop editing other cells when starting another one */
- (BOOL)cellShouldBeginEditing:(EditableTableViewCell *)cell
{
	return self.editing;
}

/* cell stopped editing */
- (void)cellDidEndEditing:(EditableTableViewCell *)cell
{
	//
}

/* keyboard about to show */
- (void)keyboardWillShow:(NSNotification *)notif
{
	// XXX: do we need this with our small view?
}

#pragma mark - UIViewController delegate methods

/* about to appear */
- (void)viewWillAppear:(BOOL)animated
{
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												name:UIKeyboardWillShowNotification
												object:self.view.window];

	[super viewWillAppear: animated];
}

/* about to disappear */
- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
												name:UIKeyboardWillShowNotification
												object:nil]; 

	[super viewWillDisappear: animated];
}

@end
