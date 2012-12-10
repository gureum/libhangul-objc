//
//  HGInputContext.m
//  CharmIM
//
//  Created by youknowone on 11. 9. 1..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "HGInputContext.h"

#define dlog(...)
#define DEBUG_HANGUL FALSE

@implementation HGKeyboard 
@synthesize data=_data;

//! @ref hangul_keyboard_new
- (id)init {
    self = [super init];
    if (self) {
        self->_data = hangul_keyboard_new();
        // 생성 실패 처리
        if (self->_data == NULL) {
            [self release];
            return nil;
        }
        self->flags.freeWhenDone = NO;
    }
    return self;
}

- (id)initWithKeyboardData:(HangulKeyboard *)keyboardData freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self) {
        self->_data = keyboardData;
        self->flags.freeWhenDone = freeWhenDone;
    }
    return self;
}

+ (id)keyboardWithKeyboardData:(HangulKeyboard *)keyboardData freeWhenDone:(BOOL)YesOrNo {
    return [[[self alloc] initWithKeyboardData:keyboardData freeWhenDone:YesOrNo] autorelease];
}

- (void)dealloc {
    if (self->flags.freeWhenDone) {
        hangul_keyboard_delete(self->_data);
    }
    [super dealloc];
}

- (void)setValue:(HGUCSChar)value forKey:(int)key {
    hangul_keyboard_set_value(self->_data, key, value);
}

- (void)setType:(int)type {
    hangul_keyboard_set_type(self->_data, type);
}

@end

@implementation HGInputContext
@synthesize context=_context;

- (id)initWithKeyboardIdentifier:(NSString *)code
{
    self = [super init];
    if (self) {
        self->_context = hangul_ic_new([code UTF8String]);
        // 생성 실패 처리
        if (self->_context == NULL) {
            [self release];
            self = nil;
        }
    }
    return self;
}

- (void)dealloc
{
    hangul_ic_delete(self->_context);
    [super dealloc];
}

- (BOOL)process:(int)ascii {
    return (BOOL)hangul_ic_process(self->_context, ascii);
}

- (void)reset {
    hangul_ic_reset(self->_context);
}

- (BOOL)backspace {
    return (BOOL)hangul_ic_backspace(self->_context);
}

- (BOOL)isEmpty {
    return (BOOL)hangul_ic_is_empty(self->_context);
}

- (BOOL)hasChoseong {
    return (BOOL)hangul_ic_has_choseong(self->_context);
}

- (BOOL)hasJungseong {
    return (BOOL)hangul_ic_has_jungseong(self->_context);
}

- (BOOL)hasJongseong {
    return (BOOL)hangul_ic_has_jongseong(self->_context);
}

- (BOOL)isTransliteration {
    return (BOOL)hangul_ic_is_transliteration(self->_context);
}

- (NSString *)preeditString {
    NSString *string = [NSString stringWithUCSString:hangul_ic_get_preedit_string(self->_context)];
    dlog(DEBUG_HANGUL, @"** HGInputContext -preeditString : %@", string);
    return string;
}

- (const HGUCSChar *)preeditUCSString {
    return hangul_ic_get_preedit_string(self->_context);
}

- (NSString *)commitString {
    NSString *string = [NSString stringWithUCSString:hangul_ic_get_commit_string(self->_context)];
    dlog(DEBUG_HANGUL, @"** HGInputContext -commitString : %@", string);
    return string;
}

- (const HGUCSChar *)commitUCSString {
    return hangul_ic_get_commit_string(self->_context);
}

- (NSString *)flushString {
    NSString *string = [NSString stringWithUCSString:hangul_ic_flush(self->_context)];
    dlog(DEBUG_HANGUL, @"** HGInputContext -flushString : %@", string);
    return string;
}

- (const HGUCSChar *)flushUCSString {
    return hangul_ic_flush(self->_context);
}

- (void)setOutputMode:(HGOutputMode)mode {
    hangul_ic_set_output_mode(self->_context, mode);
}

- (void)setKeyboard:(HGKeyboard *)aKeyboard {
    hangul_ic_set_keyboard(self->_context, aKeyboard.data);
}

- (void)setKeyboardWithData:(HangulKeyboard *)keyboardData {
    hangul_ic_set_keyboard(self->_context, keyboardData);
}

- (void)setKeyboardWithIdentifier:(NSString *)identifier {
    hangul_ic_select_keyboard(self->_context, [identifier UTF8String]);
}

- (void)setCombination:(HangulCombination *)aCombination {
    hangul_ic_set_combination(self->_context, aCombination);
}

@end

inline NSString *HGKeyboardIdentifierAtIndex(NSUInteger index) {
    return [NSString stringWithUTF8String:hangul_ic_get_keyboard_id((unsigned)index)];
}

inline NSString *HGKeyboardNameAtIndex(NSUInteger index) {
    return [NSString stringWithUTF8String:hangul_ic_get_keyboard_name((unsigned)index)];
}
