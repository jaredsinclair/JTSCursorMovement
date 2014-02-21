//
//  JTSCursorMovement.h
//  Cursory
//
//  Created by Jared Sinclair on 2/20/14.
//  Copyright (c) 2014 Jared Sinclair All rights reserved.
//

@import UIKit;

///-------------------------------------
/// JTSCursorSwipeRecognizer
///-------------------------------------

/**
 A vanilla subclass of UISwipeGestureRecognizer, JTSCursorSwipeRecognizer allows apps with complex gesture
 recognizer setups to more easily handle potential conflicts as they arise.
 */
@interface JTSCursorSwipeRecognizer : UISwipeGestureRecognizer

@end

///-------------------------------------
/// JTSCursorMovement
///-------------------------------------

@interface JTSCursorMovement : NSObject

/**
 The text view passed as the `textView` in the designated initializer.
 */
@property (weak, nonatomic, readonly) UITextView *textView;

/**
 Setting this will enable/disable JTSCursorMovement's gesture recognizers.
 */
@property (assign, nonatomic, readwrite) BOOL enabled;

/**
 Designated initializer. Performs all setup. This method is all you'll usually need to use.
 
 @param textView JTSCursorMovement keeps a weak reference to this text view.
 
 @return Returns a fully-prepared cursor movement instance. 
 
 @note You'll need to maintain a strong reference to a JTSCursorMovement instance.
 
 */
- (instancetype)initWithTextView:(UITextView *)textView;

@end

///-------------------------------------
/// JTSCursorMovement | Gesture Recognizers
///-------------------------------------

/**
 These gesture recognizers are added to the text view during initialization. They are 
 only exposed for those apps that might need to know about them. Handle them with care.
 */
@interface JTSCursorMovement (GestureRecognizers)

@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer_threeFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer_threeFingers;

@end



