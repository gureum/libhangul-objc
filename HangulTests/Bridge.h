//
//  Bridge.h
//  Hangul
//
//  Created by Jeong YunWon on 2017. 8. 31..
//  Copyright © 2017년 youknowone.org. All rights reserved.
//

#ifndef Bridge_h
#define Bridge_h

#include "hangul.h"

extern bool
hangul_ic_push(HangulInputContext *hic, ucschar c);
extern bool
hangul_ic_process_3finalsun(HangulInputContext *hic, ucschar ch);

#endif /* Bridge_h */
