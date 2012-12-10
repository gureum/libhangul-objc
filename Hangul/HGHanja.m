//
//  HGHanja.m
//  Hangul
//
//  Created by youknowone on 12. 1. 4..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#include <Hangul/hangul.h>

#import <objc/runtime.h>
#import "HGHanja.h"

@interface HGHanja ()

- (id)initWithCHanja:(const Hanja *)cHanja;
+ (id)hanjaWithCHanja:(const Hanja *)cHanja;

@end

@implementation HGHanja
@synthesize cHanja=_cHanja;

- (id)initWithCHanja:(const Hanja *)cHanja {
    if (cHanja == NULL) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self != nil) {
        self->_cHanja = cHanja;
    }
    return self;
}

+ (id)hanjaWithCHanja:(const Hanja *)cHanja {
    return [[[self alloc] initWithCHanja:cHanja] autorelease];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@('%@':'%@')('%@')>", self.className, self.key, self.value, self.comment];
}

#pragma mark 

- (NSString *)key {
    const char *cstr = hanja_get_key(self->_cHanja);
    return [[[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO] autorelease];
}

- (NSString *)value {
    const char *cstr = hanja_get_value(self->_cHanja);
    return [[[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO] autorelease];
}

- (NSString *)comment {
    const char *cstr = hanja_get_comment(self->_cHanja);
    return [[[NSString alloc] initWithBytesNoCopy:(void *)cstr length:strlen(cstr) encoding:NSUTF8StringEncoding freeWhenDone:NO] autorelease];
}

@end

@interface HGHanjaList ()

- (id)initWithCHanjaList:(HanjaList *)cHanjaList;
+ (id)listWithCHanjaList:(HanjaList *)cHanjaList;

@end

@implementation HGHanjaTable
@synthesize cTable=_cTable;

- (id)init {
    NSBundle *bundle = [NSBundle bundleForClass:[HGHanjaTable class]];
    return [self initWithContentOfFile:[bundle pathForResource:@"all" ofType:@"txt"]];
}

- (id)initWithContentOfFile:(NSString *)path {
    self = [super init];
    if (self != nil) {
        self->_cTable = hanja_table_load(path.UTF8String);
    }
    return self;
}

- (void)dealloc {
    hanja_table_delete(self->_cTable);
    [super dealloc];
}

- (HGHanjaList *)hanjasByExactMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_exact(self->_cTable, key.UTF8String)];
}

- (HGHanjaList *)hanjasByPrefixMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_prefix(self->_cTable, key.UTF8String)];    
}

- (HGHanjaList *)hanjasBySuffixMatching:(NSString *)key {
    return [HGHanjaList listWithCHanjaList:hanja_table_match_suffix(self->_cTable, key.UTF8String)];
}

@end

@implementation HGHanjaList
@synthesize cList=_cList, array=_array;

- (id)initWithCHanjaList:(HanjaList *)cHanjaList  {
    if (cHanjaList == NULL) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self != nil) {
        self->_cList = cHanjaList;
    }
    return self;
}

+ (id)listWithCHanjaList:(HanjaList *)cHanjaList {
    return [[[self alloc] initWithCHanjaList:cHanjaList] autorelease];
}

- (void)dealloc {
    [self->_array release];
    hanja_list_delete(self->_cList);
    [super dealloc];
}

- (NSInteger)count {
    return hanja_list_get_size(self->_cList);
}

- (NSString *)key {
    const char *key = hanja_list_get_key(self->_cList);
    return [[[NSString alloc] initWithBytesNoCopy:(void *)key length:strlen(key) encoding:NSUTF8StringEncoding freeWhenDone:NO] autorelease];
}

- (HGHanja *)hanjaAtIndex:(NSInteger)index {
    const Hanja *cHanja = hanja_list_get_nth(self->_cList, index);
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
    return [NSString stringWithFormat:@"<%s('%@') %@>", class_getName(self.class), self.key, self.array.description];
}

#pragma mark fast enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])buffer count:(NSUInteger)len {
    NSUInteger count = 0;
    if (state->state == 0) {
        state->mutationsPtr = &state->extra[0];
    }
    NSUInteger listCount = hanja_list_get_size(self->_cList);
    if (state->state < listCount) {
        state->itemsPtr = buffer;
        while ((state->state < listCount) && (count < len)) {
            const Hanja *cHanja = hanja_list_get_nth(self->_cList, state->state);
            buffer[count] = [HGHanja hanjaWithCHanja:cHanja];
            state->state += 1;
            count += 1;
        }
    } else {
        count = 0;
    }
    return count;
}

@end
