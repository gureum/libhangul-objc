//
//  HangulTests.swift
//  HangulTests
//
//  Created by Jeong YunWon on 2017. 8. 31..
//  Copyright © 2017 youknowone.org. All rights reserved.
//

import XCTest

func ord(_ c: String) -> Int32 {
    return Int32(c.unicodeScalars.first!.value)
}

class HangulTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
    func testKeyboard1() {
        hangul_init()
        let hic = hangul_ic_new("3fx")
        hangul_ic_process(hic, ord(c: "m"))
        hangul_ic_process(hic, ord(c: "f"))
        hangul_ic_process(hic, ord(c: "["))
        hangul_ic_process(hic, ord(c: "s"))
        print(hic)
    }*/

    func testKeyboard2() {
        hangul_init();
        let hic = hangul_ic_new("3gs")
        hangul_ic_process(hic, ord(c: "j"))
        hangul_ic_process(hic, ord(c: "t"))
        hangul_ic_process(hic, ord(c: "["))
        hangul_ic_process(hic, ord(c: "x"))
        print(hic)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
