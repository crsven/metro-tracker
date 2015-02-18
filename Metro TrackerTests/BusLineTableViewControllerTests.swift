//
//  BusLineTableViewControllerTests.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import UIKit
import XCTest

class BusLineTableViewControllerTests: XCTestCase {
    var vc:BusLineTableViewController = BusLineTableViewController()

    override func setUp() {
        super.setUp()

        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("MetroTrackerStoryboard") as BusLineTableViewController
        vc.loadView()
        vc.viewDidLoad()
        vc.busLines = [
            BusLine(runName: "line 1", routeNumber: "1", runNumber: "1-2"),
            BusLine(runName: "line 2", routeNumber: "1", runNumber: "1-3"),
            BusLine(runName: "line 3", routeNumber: "1", runNumber: "1-4")
        ]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertNotNil(vc.view, "View Did Not load")
    }

    func testBusLineCount() {
        XCTAssertEqual(vc.busLines.count, 3)
    }
}
