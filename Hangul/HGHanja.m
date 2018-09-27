//
//  HGHanja.m
//  Hangul
//
//  Created by youknowone on 12. 1. 4..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

@import ObjectiveC.runtime;

#include "hangul.h"
#import "HGHanja.h"

@interface HGHanja ()

- (id)initWithCHanja:(const Hanja *)cHanja;
+ (id)hanjaWithCHanja:(const Hanja *)cHanja;

@end

@implementation HGHanja
@synthesize cHanja=_cHanja;

- (instancetype)initWithCHanja:(const Hanja *)cHanja {
    if (cHanja == NULL) {
        return nil;
    }
    self = [super init];
    if (self != nil) {
        self->_cHanja = cHanja;
    }
    return self;
}

+ (instancetype)hanjaWithCHanja:(const Hanja *)cHanja {
    return [[self alloc] initWithCHanja:cHanja];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@('%@':'%@')('%@')>", self.className, self.key, self.value, self.comment];
}

#pragma mark 

- (NSString *)key {
    const char *cstr = hanja_get_key(self->_cHanja);
    return [[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO];
}

- (NSString *)value {
    const char *cstr = hanja_get_value(self->_cHanja);
    return [[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO];
}

- (NSString *)comment {
    const char *cstr = hanja_get_comment(self->_cHanja);
    return [[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO];
}

@end

@interface HGHanjaList ()

- (id)initWithCHanjaList:(HanjaList *)cHanjaList;
+ (id)listWithCHanjaList:(HanjaList *)cHanjaList;

@end

@implementation HGHanjaTable
@synthesize cTable=_cTable;

- (instancetype)init {
    NSBundle *bundle = [NSBundle mainBundle];
    return [self initWithContentOfFile:[bundle pathForResource:@"hanja" ofType:@"txt" inDirectory:@"hanja"]];
}

- (instancetype)initWithContentOfFile:(NSString *)path {
    self = [super init];
    if (self != nil) {
        self->_path = path;
        self->_cTable = hanja_table_load(path.UTF8String);
    }
    return self;
}

- (void)dealloc {
    hanja_table_delete(self->_cTable);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<HGHanjaTable: %@>", self->_path];
}

- (nullable HGHanjaList *)hanjasByExactMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_exact(self->_cTable, key.UTF8String)];
}

- (nullable HGHanjaList *)hanjasByPrefixMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_prefix(self->_cTable, key.UTF8String)];    
}

- (nullable HGHanjaList *)hanjasBySuffixMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_suffix(self->_cTable, key.UTF8String)];
}

- (nullable HGHanjaList *)hanjasByPrefixSearching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_search_prefix(self->_cTable, key.UTF8String)];
}

@end


@implementation HGHanjaList
@synthesize cList=_cList, array=_array;

- (instancetype)initWithCHanjaList:(HanjaList *)cHanjaList  {
    if (cHanjaList == NULL) {
        return nil;
    }
    self = [super init];
    if (self != nil) {
        self->_cList = cHanjaList;
    }
    return self;
}

+ (instancetype)listWithCHanjaList:(HanjaList *)cHanjaList {
    return [[self alloc] initWithCHanjaList:cHanjaList];
}

- (void)dealloc {
    hanja_list_delete(self->_cList);
}

- (NSUInteger)count {
    return hanja_list_get_size(self->_cList);
}

- (NSString *)key {
    const char *key = hanja_list_get_key(self->_cList);
    return [[NSString alloc] initWithBytesNoCopy:(void *)key length:strlen(key) encoding:NSUTF8StringEncoding freeWhenDone:NO];
}

- (HGHanja *)hanjaAtIndex:(NSUInteger)index {
    const Hanja *cHanja = hanja_list_get_nth(self->_cList, (unsigned)index);
    return [HGHanja hanjaWithCHanja:cHanja];
}

- (NSArray *)array {
    if (self->_array == nil) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (HGHanja *hanja in self) {
            [mArray addObject:hanja];
        }
        self->_array = [[NSArray alloc] initWithArray:mArray];
    }
    return self->_array;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s('%@',%lu)>", class_getName(self.class), self.key, self.count];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    const Hanja *cHanja = hanja_list_get_nth(self->_cList, (unsigned)idx);
    return [HGHanja hanjaWithCHanja:cHanja];
}

#pragma mark fast enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    if (state->state == 0) {
        state->extra[0] = self.count;
        state->mutationsPtr = &state->extra[0];
    }

    NSUInteger listCount = state->extra[0];
    NSUInteger count = 0;
    state->itemsPtr = buffer;
    while ((state->state < listCount) && (count < len)) {
        buffer[count] = self[state->state];
        state->state += 1;
        count += 1;
    }
    return count;
}

@end
