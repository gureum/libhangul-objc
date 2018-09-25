//
//  HGInputContext.h
//  CharmIM
//
//  Created by youknowone on 11. 9. 1..
//  Copyright 2011 youknowone.org. All rights reserved.
//

/*!
    @header
    @brief  See hangul.h and hangulinputcontext.c to see related libhangul functions
 
    libhangul의 hangul input context 코드를 Objective-C 객체 모델로 감싼다. 관련 libhangul 함수를 보기 위해서 hangul/hangul.h와 hangul/hangulinputcontext.c 를 본다.
*/

#import <Foundation/Foundation.h>
#import <Hangul/HGCharacter.h>

/*!
    @brief  See @ref HangulKeyboard
 
    @ref HGInputContext 를 위해 새 데이터를 만들때는 -init 을, 원래의 HangulKeyboard 데이터를 변환하기 위해서는 -initWithKeyboardData:freeWhenDone: 과 -keyboardWithKeyboardData:freeWhenDone: 을 사용한다.
*/
@interface HGKeyboard : NSObject {
    HangulKeyboard *_data;
    struct {
        unsigned freeWhenDone:1;
    } flags;
}
/*! @property
    @brief  미구현 기능을 위해 HangulKeyboard 객체에 접근할 때 사용한다.
*/
@property(nonatomic, readonly) HangulKeyboard *data;

//! @brief  HangulKeyboard 데이터를 기반으로 객체 생성
- (instancetype)initWithKeyboardData:(HangulKeyboard *)data freeWhenDone:(BOOL)YesOrNo NS_DESIGNATED_INITIALIZER;
//! @brief  HangulKeyboard 데이터를 기반으로 객체 생성
+ (instancetype)keyboardWithKeyboardData:(HangulKeyboard *)data freeWhenDone:(BOOL)YesOrNo;

//! @brief  See @ref hangul_keyboard_set_type
- (void)setType:(int)type;

@end

/*!
    @brief  출력 형태에 관한 상수
*/
typedef NS_ENUM(unsigned int, HGOutputMode) {
    HGOutputModeSyllable = HANGUL_OUTPUT_SYLLABLE,
    HGOutputModeJamo = HANGUL_OUTPUT_JAMO,
};

/*!
    @brief  See @ref HangulInputContext
 
    @ref HangulInputContext 의 기능에 대한 Objective-C의 객체 모델을 제공한다. 객체 모델이 지원하지 않는 기능에 대해서는 -context 로 libhangul의 컨텍스트에 직접 접근하여 사용할 수 있다.
*/
@interface HGInputContext : NSObject {
    HangulInputContext *_context;
}

//! @brief  미구현 기능을 이용하기 위해 HangulInputContext 에 직접 접근
@property(nonatomic, readonly) HangulInputContext *context;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
//! @brief  See @ref hangul_ic_new @ref hangul_ic_delete
- (instancetype)initWithKeyboardIdentifier:(NSString *)code NS_DESIGNATED_INITIALIZER;
//! @brief  See @ref hangul_ic_process
- (BOOL)process:(uint32_t)ascii;
//! @brief  See @ref hangul_ic_reset
- (void)reset;
//! @brief  See @ref hangul_ic_backspace
- (BOOL)backspace;

//! @brief  See @ref hangul_ic_is_empty
@property(nonatomic, readonly, getter=isEmpty) BOOL empty;
//! @brief  See @ref hangul_ic_has_choseong
@property(nonatomic, readonly) BOOL hasChoseong;
//! @brief  See @ref hangul_ic_has_jungseong
@property(nonatomic, readonly) BOOL hasJungseong;
//! @brief  See @ref hangul_ic_has_jongseong
@property(nonatomic, readonly) BOOL hasJongseong;
//! @brief  See @ref hangul_ic_is_transliteration
@property(nonatomic, readonly, getter=isTransliteration) BOOL transliteration;
/*!
    @brief  See @ref hangul_ic_preedit_string
 
    @ref IMKInputController 의 -composedString 과 대응한다.
*/
@property(nonatomic, readonly) NSString *preeditString;
//! @brief  See @ref hangul_ic_preedit_string
@property(nonatomic, readonly) const HGUCSChar *preeditUCSString;
//! @brief  See @ref hangul_ic_commit_string
@property(nonatomic, readonly) NSString *commitString;
//! @brief  See @ref hangul_ic_commit_string
@property(nonatomic, readonly) const HGUCSChar *commitUCSString;
/*!
    @brief  See @ref hangul_ic_flush
 
    @discussion     현재 조합 중인 글자의 조합을 완료하고 @ref preeditString 을 결과로 돌려준다.
*/
- (NSString *)flushString; // unclear naming...
//! @brief  See @ref hangul_ic_flush
- (const HGUCSChar *)flushUCSString;

//! @brief  See @ref hangul_ic_set_output_mode
- (void)setOutputMode:(HGOutputMode)mode;
//! @brief  See @ref hangul_ic_set_keyboard
- (void)setKeyboard:(HGKeyboard *)aKeyboard;
//! @brief  See @ref hangul_ic_set_keyboard
- (void)setKeyboardWithData:(HangulKeyboard *)keyboardData;
//! @brief  See @ref hangul_ic_select_keyboard
- (void)setKeyboardWithIdentifier:(NSString *)identifier;

/* out of use, out of mind
void hangul_ic_connect_callback(HangulInputContext* hic, const char* event,
                                void* callback, void* user_data);

*/
@end

/* out of use, out of mind
unsigned    hangul_ic_get_n_keyboards();
*/
//! @brief  See @ref hangul_ic_get_keyboard_id
NSString *HGKeyboardIdentifierAtIndex(NSUInteger index);
//! @brief  See @ref hangul_ic_get_keyboard_name
NSString *HGKeyboardNameAtIndex(NSUInteger index);

