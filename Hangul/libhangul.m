//
//  libhangul.m
//  Hangul
//
//  Created by Jeong YunWon on 2018. 9. 26..
//  Copyright © 2018년 youknowone.org. All rights reserved.
//

@import Foundation;

const char *libhangul_data_dir() {
    NSBundle *hangulBundle = [NSBundle mainBundle];
    NSString *path = hangulBundle.resourcePath;
    return path.fileSystemRepresentation;
}
