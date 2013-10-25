%config(generator=internal)

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>

@interface SOInputLine : NSTextView
@end

@interface SOInputLineViewController : NSViewController

- (SOInputLine *)inputLine;
- (NSTextStorage *)textStorage;

@end

static const unichar Alef = 1488;
static const unichar Tav = 1514;

BOOL DoesStringContainHebrew(NSString *s)
{
    for (NSUInteger i = 0; i < [s length]; i++) {
        unichar c = [s characterAtIndex:i];
        if (c <= Tav && c >= Alef) {
            return YES;
        }
    }
    
    return NO;
}

%hook SOInputLineViewController

- (void)textDidChange:(id)sender
{
    SOInputLine *line = [self inputLine];
    
    if (DoesStringContainHebrew([[self textStorage] string])) {
        line.alignment = NSRightTextAlignment;
    } else {
        line.alignment = NSNaturalTextAlignment;
    }
    
    %orig;
}


%end
