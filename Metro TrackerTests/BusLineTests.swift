//
//  BusLineTests.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import XCTest

class BusLineTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanInitWithName() {
        let newRunName = "A Great Line"
        let newRunNumber = "720_05_15"
        let newRouteNumber = "720"
        let busLine = BusLine(runName: newRunName, routeNumber: newRouteNumber, runNumber: newRunNumber)

        XCTAssertEqual(busLine.runName, newRunName)
        XCTAssertEqual(busLine.runNumber, newRunNumber)
        XCTAssertEqual(busLine.routeNumber, newRouteNumber)
    }
}
