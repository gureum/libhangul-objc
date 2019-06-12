//
//  HGCharacter.m
//  Hangul
//
//  Created by youknowone on 11. 9. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#include "hangul.h"
#include "hangulinternals.h"

#import "HGCharacter.h"

inline BOOL HGCharacterIsChoseong(HGUCSChar character) {
    return (BOOL)hangul_is_choseong(character);
}

inline BOOL HGCharacterIsJungseong(HGUCSChar character) {
    return (BOOL)hangul_is_jungseong(character);
}

inline BOOL HGCharacterIsJongseong(HGUCSChar character) {
    return (BOOL)hangul_is_jongseong(character);
}

inline BOOL HGCharacterIsChoseongConjoinable(HGUCSChar character) {
    return (BOOL)hangul_is_choseong_conjoinable(character);
}

inline BOOL HGCharacterIsJungseongConjoinable(HGUCSChar character) {
    return (BOOL)hangul_is_jungseong_conjoinable(character);
}

inline BOOL HGCharacterIsJongseongConjoinable(HGUCSChar character) {
    return (BOOL)hangul_is_jongseong_conjoinable(character);
}

inline BOOL HGCharacterIsSyllable(HGUCSChar character) {
    return (BOOL)hangul_is_syllable(character);
}

inline BOOL HGCharacterIsJamo(HGUCSChar character) {
    return (BOOL)hangul_is_jamo(character);
}

inline BOOL HGCharacterIsCompatibleJamo(HGUCSChar character) {
    return (BOOL)hangul_is_cjamo(character);
}

inline HGUCSChar HGCompatibleJamoFromJamo(HGUCSChar character) {
    return hangul_jamo_to_cjamo(character);
}

inline HGUCSChar HGJongseongFromChoseong(HGUCSChar character) {
    return hangul_choseong_to_jongseong(character);
}

inline HGUCSChar HGChoseongFromJongseong(HGUCSChar character) {
    return hangul_jongseong_to_choseong(character);
}

inline void HGGetDecomposedCharactersFromJongseong(HGUCSChar character,
                                                   HGUCSChar* jongseong, 
                                                   HGUCSChar* choseong) {
    return hangul_jongseong_decompose(character, jongseong, choseong);
}

inline const HGUCSChar* HGPreviousSyllableInJamoString(const HGUCSChar* jamoString,
                                                       const HGUCSChar* begin) {
    return hangul_syllable_iterator_prev(jamoString, begin);
}

inline const HGUCSChar* HGNextSyllableInJamoString(const HGUCSChar* jamoString,
                                                   const HGUCSChar* end) {
    return hangul_syllable_iterator_next(jamoString, end);
}

inline NSInteger HGSyllableLength(const HGUCSChar *string, NSInteger maxLength) {
    return (NSInteger)hangul_syllable_len(string, (int)maxLength);
}

inline HGUCSChar HGSyllableFromJamo(HGUCSChar choseong, HGUCSChar jungseong, 
                                    HGUCSChar jongseong) {
    return hangul_jamo_to_syllable(choseong, jungseong, jongseong);
}

inline void HGGetJamoFromSyllable(HGUCSChar syllable, HGUCSChar *choseong, 
                                  HGUCSChar *jungseong, HGUCSChar *jongseong) {
    return hangul_syllable_to_jamo(syllable, choseong, jungseong, jongseong);
}

inline NSInteger HGGetSyllablesFromJamos(const HGUCSChar* jamos, NSInteger jamosLength,
                                         HGUCSChar* syllables, NSInteger syllablesLength) {
    return (NSInteger)hangul_jamos_to_syllables(syllables, (int)syllablesLength, jamos, (int)jamosLength);
}


#include <wchar.h>

@implementation NSString (HGUCS)

- (instancetype)initWithUCSString:(const HGUCSChar *)ucsString {
    NSInteger length = wcslen((const wchar_t *)ucsString); // XXX: 길이 알아내는 or 길이 없이 NSString 만드는 방법이 있을까?
    // initWithCString + UTF32LE 로는 안된다. null 문자가 보이면 무조건 종료하는 듯
    //return [self initWithBytesNoCopy:(void *)ucsString length:length encoding:NSUTF32LittleEndianStringEncoding freeWhenDone:NO];
    return [self initWithBytes:ucsString length:length*sizeof(HGUCSChar) encoding:NSUTF32LittleEndianStringEncoding];
}

- (instancetype)initWithUCSString:(const HGUCSChar *)ucsString length:(NSUInteger)length {
    return [self initWithBytes:ucsString length:length*sizeof(HGUCSChar) encoding:NSUTF32LittleEndianStringEncoding];
}

+ (instancetype)stringWithUCSString:(const HGUCSChar *)ucsString {
    return [[self alloc] initWithUCSString:ucsString];
}

+ (instancetype)stringWithUCSString:(const HGUCSChar *)ucsString length:(NSUInteger)length {
    return [[self alloc] initWithUCSString:ucsString length:length];
}

@end

