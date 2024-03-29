//
//  HGInputContext.m
//  Hangul
//
//  Created by youknowone on 11. 9. 1..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "HGInputContext.h"

extern unsigned hangul_keyboard_list_load_dir(const char* path);

#define dlog(...)
#define DEBUG_HANGUL FALSE

NS_ASSUME_NONNULL_BEGIN

__attribute__((constructor))
static void HangulInitialize() {
    static bool initialized = 0;
    if (!initialized) {
        // Initialization code.
        initialized = 1;
        hangul_init();

        // load keyboad data
        NSBundle *hangulBundle = [NSBundle bundleForClass:[HGKeyboard class]];
        NSString *dataPath = hangulBundle.resourcePath;
        NSString *keyboardsPath = [dataPath stringByAppendingString:@"/keyboards"];
        hangul_keyboard_list_load_dir(keyboardsPath.fileSystemRepresentation);
    }
}

__attribute__((destructor))
static void HangulFinalize() {
    hangul_fini();
}

@implementation HGKeyboard
@synthesize data=_data;

//! @ref hangul_keyboard_new
- (instancetype)init {
    self = [self init];
    if (self) {
        self->_data = hangul_keyboard_new();
        // 생성 실패 처리
        if (self->_data == NULL) {
            return nil;
        }
        self->flags.freeWhenDone = NO;
    }
    return self;
}

- (instancetype)initWithKeyboardData:(HangulKeyboard *)keyboardData freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self) {
        self->_data = keyboardData;
        self->flags.freeWhenDone = freeWhenDone;
    }
    return self;
}

+ (instancetype)keyboardWithKeyboardData:(HangulKeyboard *)keyboardData freeWhenDone:(BOOL)YesOrNo {
    return [[self alloc] initWithKeyboardData:keyboardData freeWhenDone:YesOrNo];
}

- (void)dealloc {
    if (self->flags.freeWhenDone) {
        hangul_keyboard_delete(self->_data);
    }
}

- (void)setType:(int)type {
    hangul_keyboard_set_type(self->_data, type);
}

@end

@implementation HGInputContext
@synthesize context=_context;

- (instancetype)init  {
    return [super init];
}

- (nullable instancetype)initWithKeyboardIdentifier:(NSString *)code {
    self = [super init];
    if (self) {
        self->_context = hangul_ic_new(code.UTF8String);
        // 생성 실패 처리
        if (self->_context == NULL) {
            self = nil;
        }
    }
    return self;
}

- (void)dealloc {
    hangul_ic_delete(self->_context);
}

- (BOOL)process:(uint32_t)ascii {
    return (BOOL)hangul_ic_process(self->_context, ascii);
}

- (void)reset {
    hangul_ic_reset(self->_context);
}

- (BOOL)backspace {
    return (BOOL)hangul_ic_backspace(self->_context);
}

- (void)setOption:(NSInteger)option value:(BOOL)value {
    hangul_ic_set_option(self->_context, (int)option, value);
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
    hangul_ic_select_keyboard(self->_context, identifier.UTF8String);
}

@end

inline NSString *HGKeyboardIdentifierAtIndex(NSUInteger index) {
    return @(hangul_keyboard_list_get_keyboard_id((unsigned)index));
}

inline NSString *HGKeyboardNameAtIndex(NSUInteger index) {
    return @(hangul_keyboard_list_get_keyboard_name((unsigned)index));
}

NS_ASSUME_NONNULL_END
