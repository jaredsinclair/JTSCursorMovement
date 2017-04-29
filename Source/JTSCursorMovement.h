//
//  JTSCursorMovement.h
//  Cursory
//
//  Created by Jared Sinclair on 2/20/14.
//  Copyright (c) 2014 Jared Sinclair All rights reserved.
//

@import UIKit;

@class JTSCursorSwipeRecognizer, JTSCursorPanRecognizer;

typedef void (^JTSCursorMovementUpdateBlock)(void);

typedef NS_ENUM(NSInteger, JTSCursorMovementMethod) {
    JTSCursorMovementMethod_Swiping,
    JTSCursorMovementMethod_Panning
};

///-----------------------------------------------------------------------------
/// JTSCursorMovement
///-----------------------------------------------------------------------------

@interface JTSCursorMovement : NSObject

/// The text view passed as the `textView` in the designated initializer.
@property (weak, nonatomic, readonly) UITextView *textView;

/// Setting this will enable/disable JTSCursorMovement's gesture recognizers.
@property (assign, nonatomic, readwrite) BOOL enabled;

@property (nonatomic, strong) JTSCursorMovementUpdateBlock updateBlock;

/// Legacy initializer.
/// Defaults to JTSCursorMovementMethod_Swiping.
/// @param textView JTSCursorMovement keeps a weak reference to this text view.
/// @return Returns a fully-prepared cursor movement instance.
/// @note You'll need to maintain a strong reference to a JTSCursorMovement
/// instance.
- (instancetype)initWithTextView:(UITextView *)textView;

/// Designated initializer.
/// @param textView JTSCursorMovement keeps a weak reference to this text view.
/// @param method Determines whether multi-touch swipes or single-touch pans
/// are used to control cursor movement.
/// @return Returns a fully-prepared cursor movement instance.
/// @note You'll need to maintain a strong reference to a JTSCursorMovement
/// instance.
- (instancetype)initWithTextView:(UITextView *)textView
                          method:(JTSCursorMovementMethod)method;

@end

///-----------------------------------------------------------------------------
/// JTSCursorMovement | Gesture Recognizers
///-----------------------------------------------------------------------------

/// These gesture recognizers are added to the text view during initialization.
/// They are only exposed for those apps that might need to know about them.
/// Handle them with care.
@interface JTSCursorMovement (GestureRecognizers)

@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *leftSwipeRecognizer_threeFingers;
@property (strong, nonatomic, readonly) JTSCursorSwipeRecognizer *rightSwipeRecognizer_threeFingers;
@property (strong, nonatomic, readonly) JTSCursorPanRecognizer *panRecognizer;

- (BOOL)moveBy:(NSInteger)characters;

@end

///-----------------------------------------------------------------------------
/// JTSCursorSwipeRecognizer
///-----------------------------------------------------------------------------

/// A vanilla subclass of UISwipeGestureRecognizer, JTSCursorSwipeRecognizer
/// allows apps with complex gesture recognizer setups to more easily handle
/// potential conflicts as they arise.
@interface JTSCursorSwipeRecognizer : UISwipeGestureRecognizer

@end

///-----------------------------------------------------------------------------
/// JTSCursorPanRecognizer
///-----------------------------------------------------------------------------

/// A vanilla subclass of UIPanGestureRecognizer, JTSCursorPanRecognizer allows
/// apps with complex gesture recognizer setups to more easily handle potential
/// conflicts as they arise.
@interface JTSCursorPanRecognizer : UIPanGestureRecognizer

@end
