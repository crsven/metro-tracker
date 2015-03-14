//
//  BusStop.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/18/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import CoreData

class BusStop : NSManagedObject {
    @NSManaged var runDirection : String
    @NSManaged var stopName : String
    @NSManaged var line : BusLine
}