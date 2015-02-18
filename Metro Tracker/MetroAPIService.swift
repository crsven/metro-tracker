//
//  MetroAPIService.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import Alamofire

class MetroAPIService {
    let baseAPIUrl : String = "http://api.metro.net/agencies/lametro/"
    func fetchRoutes(respondTo: (run: BusLine) -> ()) {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForName("routeFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            let routeDetails : Dictionary<String, String!> = notification.userInfo! as Dictionary<String, String!>
            var busLine = BusLine(routeName: routeDetails["routeName"]!, routeNumber: routeDetails["routeNumber"]!)
            respondTo(run: busLine)
        });

        var routesURL : String = "\(baseAPIUrl)/routes/"
        Alamofire.request(.GET, routesURL)
            .validate()
            .responseJSON { (request, response, data, error) in
                if(error != nil) {
                    println(error)
                } else {
                    var fetchedRoutes = data!.valueForKey("items") as NSArray
                    for route in fetchedRoutes {
                        var routeNumber = route.valueForKey("id") as String
                        var routeName = route.valueForKey("display_name") as String
                        var userInfo : Dictionary = [
                            "routeNumber":routeNumber,
                            "routeName":routeName
                        ]
                        var runNotification = NSNotification(name: "routeFetched", object: nil, userInfo: userInfo)
                        notificationCenter.postNotification(runNotification)
                    }
                }
        }
    }
}