//
//  Constants.h
//  JDFrontend
//
//  Created by Moritz Venn on 06.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

// padding for margins
#define kLeftMargin             5
#define kTopMargin              5
#define kRightMargin            5
#define kBottomMargin           5
#define kTweenMargin            10

// control dimensions
#define kStdButtonWidth         106
#define kStdButtonHeight        40
#define kSegmentedControlHeight 40
#define kPageControlHeight      20
#define kPageControlWidth       160
#define kSliderHeight           7
#define kSwitchButtonWidth      94
#define kSwitchButtonHeight     27
#define kTextFieldHeight        ((IS_IPAD()) ? 35 : 30)
#define kTextViewHeight         ((IS_IPAD()) ? 300 : 220)
#define kSearchBarHeight        40
#define kLabelHeight            20
#define kProgressIndicatorSize  40
#define kToolbarHeight          40
#define kUIProgressBarWidth     160
#define kUIProgressBarHeight    24
#define kWideButtonWidth        220

// specific font metrics used in our text fields and text views
#define kFontName               @"Arial"
#define kTextFieldFontSize      ((IS_IPAD()) ? 22 : 18)
#define kTextViewFontSize       ((IS_IPAD()) ? 22 : 18)

// UITableView row heights
#define kUISmallRowHeight       ((IS_IPAD()) ? 43 : 38)
#define kUIRowHeight            ((IS_IPAD()) ? 55 : 50)
#define kUIRowLabelHeight       22

// shared colors
#define kInformationColor	[UIColor grayColor]
#define kSuccessColor		[UIColor colorWithRed:0 green:0.8f blue:0 alpha:1.0f]
#define kFailureColor		[UIColor redColor]

//
#define kVanilla_ID             @"Vanilla_ID"

// keys in nsuserdefaults
#define kActiveConnection       @"activeConnector"