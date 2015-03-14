//
//  BusLine.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import CoreData

class BusLine: NSManagedObject {
    @NSManaged var routeName : String
    @NSManaged var routeNumber : String
    @NSManaged var stops : NSSet
}