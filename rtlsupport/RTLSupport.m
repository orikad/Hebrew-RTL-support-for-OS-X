//
//  RTLSupport.m
//  rtlsupport
//
//  Created by Ori Kadosh on 1/3/14.
//  Copyright (c) 2014 Ori Kadosh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "RTLSupport.h"

@implementation RTLSupport

+ (NSWritingDirection)baseWritingDirection:(NSString *)string
{
    NSUInteger length = [string length];
    
    for (NSUInteger i = 0; i < length; i++) {
        
        unichar character = [string characterAtIndex:i];
        
        
        if ((character >= 'a' && character <= 'z') || (character >= 'A' && character <= 'Z')) {
            return NSWritingDirectionLeftToRight;
        }
        
        
        if (character >= L'א' && character <= L'ת') {
            return NSWritingDirectionRightToLeft;
        }
    }
    
    return [self directionFromKeyboard];
}

+ (NSWritingDirection)directionFromKeyboard
{
    NSWritingDirection writingDirection = NSWritingDirectionLeftToRight;
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    NSArray *languages = (__bridge NSArray *)(TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages));

    
    for (NSString *language in languages) {
        if ([language isEqual:@"he"]) {
            writingDirection = NSWritingDirectionRightToLeft;
            break;
        }
    }
    
    CFRelease(source);
    
    return writingDirection;
}

+ (void)textDidchange:(NSNotification *)notification
{
    NSWritingDirection writingDirection = [self baseWritingDirection:((NSTextView *)notification.object).string];
    ((NSTextView *)notification.object).alignment = writingDirection;
    ((NSControl *)notification.object).baseWritingDirection = writingDirection;
}

+ (void)languageChanged
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    NSResponder *firstResponder = [keyWindow firstResponder];
    
    if (![firstResponder isKindOfClass:[NSTextView class]]) {
        return;
    }
    
    if (![firstResponder respondsToSelector:@selector(setAlignment:)] ||
        ![firstResponder respondsToSelector:@selector(setBaseWritingDirection:)]) {
        return;
    }
    
    NSWritingDirection writingDirection = [self baseWritingDirection:((NSTextView *)firstResponder).string];
    ((NSTextView *)firstResponder).alignment = writingDirection;
    ((NSControl *)firstResponder).baseWritingDirection = writingDirection;
}

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(languageChanged:)
                                               name:NSTextInputContextKeyboardSelectionDidChangeNotification
                                             object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textDidchange:)
                                               name:NSTextDidChangeNotification
                                             object:nil];
}

@end
