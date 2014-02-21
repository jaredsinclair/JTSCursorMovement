JTSCursorMovement
=================

A drop-in utility for adding convenient swipe gesture cursor movements to a UITextView.

## Moving the Cursor

JTSCursorMovement adds convenient gesture recognizers to a UITextView that make it easy to move the cursor forward or backwards. Use one finger to move by characters, two fingers by words, and three fingers by paragraphs. JTSCursorMovement works with both plain text and attributed text, and with composed characters like emoji.

## Known Issues

JTSCursorMovement has not yet been tested with right-to-left languages.

## Usage

Setting up JTSCursorMovement is three lines of code: an import, a strong reference, and a one-line initializer.

```objc
#import "JTSCursorMovement.h"

@interface BLAViewController () 

@property (strong, nonatomic) JTSCursorMovement *cursorMovement;
@property (strong, nonatomic) UITextView *textView;

@end

[...]

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.cursorMovement = [[JTSCursorMovement alloc] initWithTextView:self.textView];
  
}

```

That's it.
