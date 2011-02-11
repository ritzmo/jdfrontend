//
//  ConfigViewController.h
//  JDFrontend
//
//  Created by Moritz Venn on 10.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellTextField.h" /* EditableTableViewCellDelegate */

/*!
 @brief Connection Settings.
 
 Allows to change settings of a known or new connection, make it default or just connect and
 finally save / dismiss changes.
 */
@interface ConfigViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate,
													UITableViewDataSource,
													EditableTableViewCellDelegate>
{
@private
	UITextField *_remoteAddressTextField; /*!< @brief  Text Field. */
	CellTextField *_remoteAddressCell; /*!< @brief Address Cell. */
	NSInteger _connectionIndex; /*!< @brief Index in List of known Connections. */
	UIButton *_makeDefaultButton; /*!< @brief "Make Default" Button. */
	UIButton *_connectButton; /*!< @brief "Connect" Button. */
	//UISwitch *_sslSwitch; /*!< @brief Switch to enable SSL. */
	NSString *_hostname; /*!< @brief Hostname of connection. */

	BOOL _mustSave;
	BOOL _shouldSave; /*!< @brief Settings should be Saved. */
}

/*!
 @brief Standard Constructor.
 
 Edit known Connection.
 
 @param newHost Hostname.
 @param atIndex Index in List of known Connections.
 @return ConfigViewController instance.
 */
+ (ConfigViewController *)withHost: (NSString *)newHost: (NSInteger)atIndex;

/*!
 @brief Standard Constructor.
 
 Create new Connection.
 
 @return ConfigViewController instance.
 */
+ (ConfigViewController *)newConnection;



/*
 @brief Hostname.
 */
@property (nonatomic, retain) NSString *hostname;

/*!
 @brief "Make Default" Button.
 */
@property (nonatomic,retain) UIButton *makeDefaultButton;

/*!
 @brief "Connect" Button.
 */
@property (nonatomic,retain) UIButton *connectButton;

/*!
 @brief Index in List of known Connections.
 */
@property (nonatomic) NSInteger connectionIndex;

/*!
 @brief Force user to save this entry.
 */
@property (nonatomic) BOOL mustSave;

@end
