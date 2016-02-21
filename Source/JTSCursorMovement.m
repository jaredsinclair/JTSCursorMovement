//
//  JTSCursorMovement.m
//  Cursory
//
//  Created by Jared Sinclair on 2/20/14.
//  Copyright (c) 2014 Jared Sinclair All rights reserved.
//

#import "JTSCursorMovement.h"

@implementation JTSCursorSwipeRecognizer
@end

@implementation JTSCursorPanRecognizer
@end

@interface JTSCursorMovement () <UIGestureRecognizerDelegate>

@property (weak, nonatomic, readwrite) UITextView *textView;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *leftSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *rightSwipeRecognizer_twoFingers;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *leftSwipeRecognizer_threeFingers;
@property (strong, nonatomic, readwrite) JTSCursorSwipeRecognizer *rightSwipeRecognizer_threeFingers;
@property (strong, nonatomic, readwrite) JTSCursorPanRecognizer *panRecognizer;
@property (nonatomic, assign) CGFloat lastPanX;
@property (nonatomic, assign) BOOL ignoreThisPanningSession;

@end

@implementation JTSCursorMovement

#pragma mark - NSObject

- (void)dealloc {
    [_leftSwipeRecognizer.view removeGestureRecognizer:_leftSwipeRecognizer];
    [_rightSwipeRecognizer.view removeGestureRecognizer:_rightSwipeRecognizer];
    [_leftSwipeRecognizer_twoFingers.view removeGestureRecognizer:_leftSwipeRecognizer_twoFingers];
    [_rightSwipeRecognizer_twoFingers.view removeGestureRecognizer:_rightSwipeRecognizer_twoFingers];
    [_leftSwipeRecognizer_threeFingers.view removeGestureRecognizer:_leftSwipeRecognizer_threeFingers];
    [_rightSwipeRecognizer_threeFingers.view removeGestureRecognizer:_rightSwipeRecognizer_threeFingers];
}

#pragma mark - JTSCursorMovement

- (instancetype)initWithTextView:(UITextView *)textView {
    return [self initWithTextView:textView method:JTSCursorMovementMethod_Swiping];
}

- (instancetype)initWithTextView:(UITextView *)textView method:(JTSCursorMovementMethod)method {
    self = [super init];
    if (self) {
        _enabled = YES;
        _textView = textView;
        switch(method) {
            case JTSCursorMovementMethod_Swiping:
                [self setupSwipeGestureRecognizersWithView:textView];
                break;
            case JTSCursorMovementMethod_Panning:
                [self setupPanGestureRecognizerWithView:textView];
                break;
        }
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
}

#pragma mark - Setup

- (void)setupSwipeGestureRecognizersWithView:(UITextView *)textView {
    
    // One Finger
    JTSCursorSwipeRecognizer *leftSwipeRecognizer = [[JTSCursorSwipeRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(swipedToTheLeft:)];
    JTSCursorSwipeRecognizer *rightSwipeRecognizer = [[JTSCursorSwipeRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(swipedToTheRight:)];
    
    // Two Fingers
    JTSCursorSwipeRecognizer *leftSwipeRecognizer_twoFingers = [[JTSCursorSwipeRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(twoFingerSwipedToTheLeft:)];
    JTSCursorSwipeRecognizer *rightSwipeRecognizer_twoFingers = [[JTSCursorSwipeRecognizer alloc]
                                                                 initWithTarget:self
                                                                 action:@selector(twoFingerSwipedToTheRight:)];
    
    // Three Fingers
    JTSCursorSwipeRecognizer *leftSwipeRecognizer_threeFingers = [[JTSCursorSwipeRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(threeFingerSwipedToTheLeft:)];
    JTSCursorSwipeRecognizer *rightSwipeRecognizer_threeFingers = [[JTSCursorSwipeRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(threeFingerSwipedToTheRight:)];
    
    // Directions and Touch Counts
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipeRecognizer_twoFingers.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeRecognizer_twoFingers.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipeRecognizer_threeFingers.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeRecognizer_threeFingers.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipeRecognizer_twoFingers.numberOfTouchesRequired = 2;
    rightSwipeRecognizer_twoFingers.numberOfTouchesRequired = 2;
    leftSwipeRecognizer_threeFingers.numberOfTouchesRequired = 3;
    rightSwipeRecognizer_threeFingers.numberOfTouchesRequired = 3;
    
    [textView addGestureRecognizer:leftSwipeRecognizer];
    [textView addGestureRecognizer:rightSwipeRecognizer];
    [textView addGestureRecognizer:leftSwipeRecognizer_twoFingers];
    [textView addGestureRecognizer:rightSwipeRecognizer_twoFingers];
    [textView addGestureRecognizer:leftSwipeRecognizer_threeFingers];
    [textView addGestureRecognizer:rightSwipeRecognizer_threeFingers];
    
    [self setLeftSwipeRecognizer:leftSwipeRecognizer];
    [self setRightSwipeRecognizer:rightSwipeRecognizer];
    [self setLeftSwipeRecognizer_twoFingers:leftSwipeRecognizer_twoFingers];
    [self setRightSwipeRecognizer_twoFingers:rightSwipeRecognizer_twoFingers];
    [self setLeftSwipeRecognizer_threeFingers:leftSwipeRecognizer_threeFingers];
    [self setRightSwipeRecognizer_threeFingers:rightSwipeRecognizer_threeFingers];
}

- (void)setupPanGestureRecognizerWithView:(UITextView *)textView {
    self.panRecognizer = [JTSCursorPanRecognizer new];
    self.panRecognizer.delegate = self;
    [self.panRecognizer addTarget:self action:@selector(panned:)];
    [textView addGestureRecognizer:self.panRecognizer];
}

#pragma mark - Enabling

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self.leftSwipeRecognizer setEnabled:_enabled];
    [self.rightSwipeRecognizer setEnabled:_enabled];
    [self.leftSwipeRecognizer_twoFingers setEnabled:_enabled];
    [self.rightSwipeRecognizer_twoFingers setEnabled:_enabled];
    [self.leftSwipeRecognizer_threeFingers setEnabled:_enabled];
    [self.rightSwipeRecognizer_threeFingers setEnabled:_enabled];
    [self.panRecognizer setEnabled:_enabled];
}

#pragma mark - Pan Actions

- (void)panned:(UIPanGestureRecognizer *)sender {
    switch(sender.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint translation = [sender translationInView:sender.view];
            self.ignoreThisPanningSession = fabs(translation.y) > 0;
            self.textView.panGestureRecognizer.enabled = self.ignoreThisPanningSession;
            self.lastPanX = 0;
        } break;
        case UIGestureRecognizerStateChanged: {
            if (!self.ignoreThisPanningSession) {
                CGFloat prevX = self.lastPanX;
                CGFloat translation = [sender translationInView:sender.view].x;
                CGFloat velocity = fabs([sender translationInView:sender.view].x);
                CGFloat delta = translation - prevX;
                CGFloat sensitivityAdjust = MAX(0.01 * velocity, 1);
                CGFloat sensitivity = 0.05 * sensitivityAdjust; // bigger == more sensitive
                NSInteger characters = roundf(delta * sensitivity);
                if (labs(characters) > 0) {
                    self.lastPanX = translation;
                    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
                        [self moveBy:-characters];
                    } else {
                        [self moveBy:characters];
                    }
                }
            }
        } break;
        default: {
            self.lastPanX = 0;
            self.ignoreThisPanningSession = NO;
            self.textView.panGestureRecognizer.enabled = YES;
        } break;
    }
}

#pragma mark - Swipe Actions

- (void)swipedToTheRight:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goBackwardOneCharacter];
    } else {
        [self goForwardOneCharacter];
    }
}

- (void)swipedToTheLeft:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goForwardOneCharacter];
    } else {
        [self goBackwardOneCharacter];
    }
}

- (void)twoFingerSwipedToTheRight:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goBackwardOneWord];
    } else {
        [self goForwardOneWord];
    }
}

- (void)twoFingerSwipedToTheLeft:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goForwardOneWord];
    } else {
        [self goBackwardOneWord];
    }
}

- (void)threeFingerSwipedToTheRight:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goBackwardOneParagraph];
    } else {
        [self goForwardOneParagraph];
    }
}

- (void)threeFingerSwipedToTheLeft:(id)sender {
    if ([self currentWritingDirection:self.textView] == UITextWritingDirectionRightToLeft) {
        [self goForwardOneParagraph];
    } else {
        [self goBackwardOneParagraph];
    }
}

#pragma mark - Direction Logic

- (UITextWritingDirection)currentWritingDirection:(id <UITextInput>)textInputObject {
    UITextWritingDirection writingDirection;
    @try {
        writingDirection = [textInputObject
                            baseWritingDirectionForPosition:textInputObject.selectedTextRange.start
                            inDirection:UITextStorageDirectionBackward];
    }
    @catch (NSException *exception) {
        writingDirection = UITextWritingDirectionLeftToRight;
    }
    @finally {
        //
    }
    return writingDirection;
}

- (void)moveBy:(NSInteger)characters {
    NSInteger location = [self indexIfMovedBy:characters];
    self.textView.selectedRange = NSMakeRange(location, 0);
}

- (void)goForwardOneCharacter {
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location < self.textView.textStorage.string.length) {
        NSInteger location = [self indexOfNextCharacter];
        self.textView.selectedRange = NSMakeRange(location, 0);
    }
}

- (void)goForwardOneWord {
    NSInteger targetIndex = [self indexOfFirstSubsequentSpace];
    self.textView.selectedRange = NSMakeRange(targetIndex, 0);
}

- (void)goForwardOneParagraph {
    NSInteger targetIndex = [self indexOfFirstSubsequentLine];
    self.textView.selectedRange = NSMakeRange(targetIndex, 0);
}

- (void)goBackwardOneCharacter {
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location > 0) {
        NSInteger location = [self indexOfPreviousCharacter];
        self.textView.selectedRange = NSMakeRange(location, 0);
    }
}

- (void)goBackwardOneWord {
    NSInteger targetIndex = [self indexOfFirstPreviousSpace];
    self.textView.selectedRange = NSMakeRange(targetIndex, 0);
}

- (void)goBackwardOneParagraph {
    NSInteger targetIndex = [self indexOfFirstPreviousLine];
    self.textView.selectedRange = NSMakeRange(targetIndex, 0);
}

#pragma mark - Index Logic

- (NSInteger)indexOfPreviousCharacter {
    
    __block NSInteger indexOfSpace = 0;
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:NSMakeRange(0, self.textView.selectedRange.location)
     options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         indexOfSpace = substringRange.location;
         *stop = YES;
         
     }];
    
    return indexOfSpace;
}

- (NSInteger)indexIfMovedBy:(NSInteger)characters {
    
    __block NSInteger targetIndex = self.textView.selectedRange.location;
    
    __block NSInteger moves = 0;
    
    NSRange range;
    NSStringEnumerationOptions options;
    if (characters < 0) {
        options = (NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationReverse);
        range = NSMakeRange(0, targetIndex);
    } else {
        options = NSStringEnumerationByComposedCharacterSequences;
        NSInteger length = self.textView.textStorage.string.length - targetIndex;
        range = NSMakeRange(targetIndex, length);
    }
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:range
     options:options
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         moves += 1;
         if (moves >= labs(characters)) {
             if (characters < 0) {
                 targetIndex = substringRange.location;
             } else {
                 targetIndex = substringRange.location + 1;
             }
             *stop = YES;
         }
     }];
    
    return targetIndex;
}

- (NSInteger)indexOfNextCharacter {
    
    __block BOOL nextCharacterReached = NO;
    __block BOOL indexChanged = NO;
    __block NSInteger indexOfSpace = self.textView.selectedRange.location;
    NSInteger length = self.textView.textStorage.string.length - self.textView.selectedRange.location;
    NSRange range = NSMakeRange(self.textView.selectedRange.location, length);
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:range
     options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         if (nextCharacterReached) {
             indexChanged = YES;
             indexOfSpace = substringRange.location;
             *stop = YES;
         }
         nextCharacterReached = YES;
     }];
    
    if (indexChanged == NO) {
        indexOfSpace = self.textView.textStorage.string.length;
    }
    
    return indexOfSpace;
}

- (NSInteger)indexOfFirstPreviousSpace {
    
    __block NSInteger indexOfSpace = 0;
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:NSMakeRange(0, self.textView.selectedRange.location)
     options:NSStringEnumerationByWords | NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         indexOfSpace = substringRange.location;
         *stop = YES;
         
     }];
    
    return indexOfSpace;
}

- (NSInteger)indexOfFirstSubsequentSpace {
    
    __block BOOL firstWordFound = NO;
    __block BOOL indexChanged = NO;
    __block NSInteger indexOfSpace = self.textView.selectedRange.location;
    NSInteger length = self.textView.textStorage.string.length - self.textView.selectedRange.location;
    NSRange range = NSMakeRange(self.textView.selectedRange.location, length);
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:range
     options:NSStringEnumerationByWords
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         if (firstWordFound) {
             indexChanged = YES;
             indexOfSpace = substringRange.location;
             *stop = YES;
         }
         firstWordFound = YES;
         
     }];
    
    if (indexChanged == NO) {
        indexOfSpace = self.textView.textStorage.string.length;
    }
    
    return indexOfSpace;
}

- (NSInteger)indexOfFirstPreviousLine {
    
    __block NSInteger indexOfSpace = 0;
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:NSMakeRange(0, self.textView.selectedRange.location)
     options:NSStringEnumerationByLines | NSStringEnumerationReverse
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         indexOfSpace = substringRange.location;
         *stop = YES;
         
     }];
    
    return indexOfSpace;
}

- (NSInteger)indexOfFirstSubsequentLine {
    
    __block BOOL firstWordFound = NO;
    __block BOOL indexChanged = NO;
    __block NSInteger indexOfSpace = self.textView.selectedRange.location;
    
    NSInteger length = self.textView.textStorage.string.length - self.textView.selectedRange.location;
    NSRange range = NSMakeRange(self.textView.selectedRange.location, length);
    
    [self.textView.textStorage.string
     enumerateSubstringsInRange:range
     options:NSStringEnumerationByLines
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         if (firstWordFound) {
             indexChanged = YES;
             indexOfSpace = substringRange.location;
             *stop = YES;
         }
         firstWordFound = YES;
     }];
    
    if (indexChanged == NO) {
        indexOfSpace = self.textView.textStorage.string.length;
    }
    
    return indexOfSpace;
}

@end
