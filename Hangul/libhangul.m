//
//  libhangul.m
//  Hangul
//
//  Created by Jeong YunWon on 2018. 9. 26..
//  Copyright © 2018 youknowone.org. All rights reserved.
//

@import Foundation;

#import "Hangul/HGInputContext.h"

const char *libhangul_data_dir() {
    NSBundle *hangulBundle = [NSBundle bundleForClass:[HGKeyboard class]];
    NSString *path = hangulBundle.resourcePath;
    return path.fileSystemRepresentation;
}
