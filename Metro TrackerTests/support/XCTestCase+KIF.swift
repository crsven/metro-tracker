//
//  XCTestCase+KIF.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 3/19/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import KIF

extension XCTestCase {

    var tester: KIFUITestActor { return tester() }
    var system: KIFSystemTestActor { return system() }
    var metroServer: MetroServer { return metroServer() }

    private func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }

    private func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }

    private func metroServer(_ file : String = __FILE__, _ line : Int = __LINE__) -> MetroServer {
        return MetroServer(inFile: file, atLine: line, delegate: self)
    }

}