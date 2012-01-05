//
//  HGHanja.h
//  Hangul
//
//  Created by youknowone on 12. 1. 4..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

/*!
 @header
 @brief  See hangul.h and hanja.c to see related libhangul functions
 
 libhangul의 한자 관련 코드를 Objective-C 객체 모델로 감싼다. 관련 libhangul 함수를 보기 위해서 hangul/hangul.h와 hangul/hanja.c 를 본다.
 */

#import <Foundation/Foundation.h>
#include <Hangul/hangul.h>

/*!
 @brief  @ref Hanja 를 감싼다.
 
 Hanja 구조체에서 key, value, comment를 가져오는 인터페이스를 제공한다.
 */
@interface HGHanja : NSObject

@property(nonatomic, readonly) const Hanja *cHanja;
@property(nonatomic, readonly) NSString *key, *value, *comment;

@end

/*!
 @brief  @ref HanjaList 를 감싼다.
 
 HanjaList 구조체에서 count, key를 가져오는 인터페이스와 NSArray 변환을 제공한다.
 */
@interface HGHanjaList : NSObject<NSFastEnumeration>

@property(nonatomic, readonly) HanjaList *cList;
@property(nonatomic, readonly) NSArray *array;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSString *key;

- (HGHanja *)hanjaAtIndex:(NSInteger)index;

@end

/*!
 @brief  @ref HanjaTable 을 감싼다.
 
 HanjaTable 의 load와 검색 인터페이스를 제공한다.
 파일을 지정하지 않고 생성할 경우 libhangul에 내장 된 기본 사전을 불러온다.
 */
@interface HGHanjaTable : NSObject

@property(nonatomic, readonly) HanjaTable *cTable;

- (id)initWithContentOfFile:(NSString *)path;

- (HGHanjaList *)hanjasByExactMatching:(NSString *)key;
- (HGHanjaList *)hanjasByPrefixMatching:(NSString *)key;
- (HGHanjaList *)hanjasBySuffixMatching:(NSString *)key;

@end
