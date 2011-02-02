//
//  SwipeTableView.h
//  JDFrontend
//
//  Created by Moritz Venn on 27.01.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Types of swipes we detect.
 */
typedef enum
{
	/*!
	 @brief No swipe detected.
	 */
	swipeTypeNone,
	/*!
	 @brief Left swipe detected.
	 */
	swipeTypeLeft,
	/*!
	 @brief Right swipe detected.
	 */
	swipeTypeRight,
#if 0
	/*!
	 @brief Upwards swipe detected.
	 */
	swipeTypeUp,
	/*!
	 @brief Downwards swipe detected.
	 */
	swipeTypeDown,
#endif
} SwipeType;

/*!
 @brief Extended Table View which detects swipes.
 We use it to be able to detect left/right swipes in a UITableView.
 While the base class does this internally (e.g. delete), we are unable to
 re-use this code so we re-implement it here.
 The class also provides us with the exact location of a previous touch.
 This way we can detect where a cell was tapped, not just that it was tapped.
 This is helpful if you emulate a table with multiple columns.
 */
@interface SwipeTableView : UITableView
{
@private
	SwipeType _lastSwipe; /*!< @brief Last swipe. */
	CGPoint _lastTouch; /*!< @brief Last touch location. */
}

/*!
 @brief Last swipe type.
 */
@property (nonatomic) SwipeType lastSwipe;

/*!
 @brief Last touch location (not relative to cell!)
 */
@property (nonatomic) CGPoint lastTouch;

@end



/*!
 @brief Protocol to be informed about swipes.
 By implementing this protocol your class will be informed about detected swipes.
 You are free to emulate this, e.g. by including logic in {will,did}SelectRowAtIndexPath
 but the results will be less convincing.
 */
@protocol SwipeTableViewDelegate
/*!
 @brief Row was swiped.

 @param tableView SwipeTableView the swipe occured in.
 @param indexPath Index Path of row.
 */
- (void)tableView:(SwipeTableView *)tableView didSwipeRowAtIndexPath:(NSIndexPath *)indexPath;
@end