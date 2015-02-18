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
    func fetchRuns(respondTo: (run: BusLine) -> ()) {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForName("runFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            let runDetails : Dictionary<String, String!> = notification.userInfo! as Dictionary<String, String!>
            var busLine = BusLine(runName: runDetails["runName"]!, routeNumber: runDetails["routeNumber"]!, runNumber: runDetails["runNumber"]!)
            respondTo(run: busLine)
        });

        var routesURL : String = "http://api.metro.net/agencies/lametro/routes/"
        Alamofire.request(.GET, routesURL)
            .validate()
            .responseJSON { (request, response, data, error) in
                var busRoutes = data!.valueForKey("items") as NSArray
                self.createRunsFromRoutes(busRoutes)
        }
    }

    func createRunsFromRoutes(routes: NSArray) {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        var runs = [BusLine]()
        for route in routes {
            var routeNumber = route.valueForKey("id") as String
            var routesURL : String = "http://api.metro.net/agencies/lametro/routes/\(routeNumber)/runs/"
            Alamofire.request(.GET, routesURL)
                .validate()
                .responseJSON { (request, response, data, error) in
                    if(error != nil) {
                        println(error)
                    } else {
                        var fetchedRuns = data!.valueForKey("items") as NSArray
                        for run in fetchedRuns {
                            var runName = run.valueForKey("display_name") as String
                            var runNumber = run.valueForKey("id") as String
                            var userInfo : Dictionary = [
                                "routeNumber":routeNumber,
                                "runNumber":runNumber,
                                "runName":runName,
                            ]
                            var runNotification = NSNotification(name: "runFetched", object: nil, userInfo: userInfo)
                            notificationCenter.postNotification(runNotification)
                        }
                    }
            }
        }
    }
}