//
//  NotificationRequest.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/26/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import CoreData

class NotificationRequest: NSManagedObject {
    @NSManaged var routeNumber: String
    @NSManaged var stopNumber: String
    @NSManaged var warningTime: Int
}
