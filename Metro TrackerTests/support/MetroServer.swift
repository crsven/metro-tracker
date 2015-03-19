//
//  MetroServer.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 3/19/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import AMYServer

class MetroServer: AMYServer {
    func baseURL() -> NSURL {
        let url = NSURL(string: "http://api.metro.net/agencies/lametro")
        return url!
    }

    func waitForRoutesRequest() {
        return waitForRequestMatchingMocktail("successful-bus-line-fetch", withHTTPBodyMatchingBlock: { (data:NSData!, error:NSErrorPointer) -> KIFTestStepResult in
            return KIFTestStepResult.Success
        }, andRespondWithValues: NSDictionary())
    }
}