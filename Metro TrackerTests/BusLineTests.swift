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
        let newRouteName = "A Great Line"
        let newRouteNumber = "720"
        let busLine = BusLine(routeName: newRouteName, routeNumber: newRouteNumber)

        XCTAssertEqual(busLine.routeName, newRouteName)
        XCTAssertEqual(busLine.routeNumber, newRouteNumber)
    }
}
