//
//  SeeBusLines.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 3/19/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import UIKit
import XCTest
import Mocktail

class SeeBusLines: KIFTestCase {

    override func setUp() {
        super.setUp()

        Mocktail.startWithContentsOfDirectoryAtURL(NSBundle.mainBundle().m

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    override func beforeAll() {
        metroServer.start()
    }

    override func afterAll() {
        metroServer.stop()
    }

    func testSeeBusLines() {
        metroServer.waitForRoutesRequest()
        tester.waitForViewWithAccessibilityLabel("Bus Line Search")
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
