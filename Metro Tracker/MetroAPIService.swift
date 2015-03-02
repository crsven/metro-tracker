//
//  MetroAPIService.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class MetroAPIService {
    let baseAPIUrl : String = "http://api.metro.net/agencies/lametro"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let notificationCenter = NSNotificationCenter.defaultCenter()

    func fetchBusLines() {
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
                        let busLine = NSEntityDescription.insertNewObjectForEntityForName("BusLine", inManagedObjectContext: self.managedObjectContext!) as BusLine
                        busLine.routeNumber = routeNumber
                        busLine.routeName = routeName

                        var runNotification = NSNotification(name: "busLinesFetched", object: nil)
                        self.notificationCenter.postNotification(runNotification)
                    }
                }
        }
    }

    func fetchStopsForRoute(route: String, respondTo: (stops: [BusStop]) -> ()) {
        notificationCenter.addObserverForName("runsFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            let runDetails : Dictionary<String, Array<AnyObject>> = notification.userInfo! as Dictionary<String, Array<AnyObject>>
            for run in runDetails["runs"]! {
                let runName : String = run.valueForKey("route_id") as String
                let runDirection : String = run.valueForKey("direction_name") as String
                var stopsURL : String = "\(self.baseAPIUrl)/routes/\(route)/runs/\(runName)/stops/"
                Alamofire.request(.GET, stopsURL)
                    .validate()
                    .responseJSON { (request, response, data, error) in
                        if(error != nil) {
                            println(error)
                        } else {
                            var fetchedStops = data!.valueForKey("items") as NSArray
                            var userInfo: Dictionary = [
                                "stops": fetchedStops,
                                "directions": [runDirection]
                            ]
                            var stopNotification = NSNotification(name: "stopsFetched", object: nil, userInfo: userInfo)
                            self.notificationCenter.postNotification(stopNotification)
                        }
                }
            }
        })

        var runsURL : String = "\(baseAPIUrl)/routes/\(route)/runs/"
        Alamofire.request(.GET, runsURL)
            .validate()
            .responseJSON { (request, response, data, error) in
                if(error != nil) {
                    println(error)
                } else {
                    var fetchedRuns = data!.valueForKey("items") as NSArray
                    var userInfo: Dictionary = [
                        "runs": fetchedRuns
                    ]
                    var runNotification = NSNotification(name: "runsFetched", object: nil, userInfo: userInfo)
                    self.notificationCenter.postNotification(runNotification)
                }
        }

        notificationCenter.addObserverForName("stopsFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            var routeDetails : Dictionary<String, Array<AnyObject>> = notification.userInfo! as Dictionary<String, Array<AnyObject>>
            var fetchedStops = [BusStop]()
            var runDirection : String = routeDetails["directions"]?.first as String
            for stop in routeDetails["stops"]! {
                let displayName : String = stop.valueForKey("display_name") as String
                let newStop : BusStop = BusStop(routeNumber: route, runDirection: runDirection, stopName: displayName)
                fetchedStops.append(newStop)
            }
            respondTo(stops: fetchedStops)
        })

    }
}