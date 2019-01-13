//
//  HangulTests.swift
//  HangulTests
//
//  Created by Jeong YunWon on 2017. 8. 31..
//  Copyright © 2017 youknowone.org. All rights reserved.
//

import Hangul
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

    func testKeyboard1() {
        hangul_init()
        let hic = hangul_ic_new("3fx")
        hangul_ic_process(hic, ord("m"))
        hangul_ic_process(hic, ord("f"))
        hangul_ic_process(hic, ord("["))
        hangul_ic_process(hic, ord("s"))
        print(hic)
    }

    func testKeyboard2() {
        hangul_init()
        let hic = hangul_ic_new("3gs")
        hangul_ic_process(hic, ord("j"))
        hangul_ic_process(hic, ord("t"))
        hangul_ic_process(hic, ord("["))
        hangul_ic_process(hic, ord("x"))
        print(hic)
    }

    func testBackspace() {
        hangul_init()
        let hic = hangul_ic_new("3gs")
        hangul_ic_process(hic, ord("j"))
        hangul_ic_process(hic, ord("t"))
        hangul_ic_process(hic, ord("["))
        hangul_ic_process(hic, ord("\u{8}"))
        print(hic as Any)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
