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

    func fetchStopsForRoute(line: BusLine) {
        notificationCenter.addObserverForName("runsFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            let runDetails : Dictionary<String, Array<AnyObject>> = notification.userInfo! as Dictionary<String, Array<AnyObject>>
            for run in runDetails["runs"]! {
                let runName : String = run.valueForKey("route_id") as String
                let runDirection : String = run.valueForKey("direction_name") as String
                var stopsURL : String = "\(self.baseAPIUrl)/routes/\(line.routeNumber)/runs/\(runName)/stops/"
                Alamofire.request(.GET, stopsURL)
                    .validate()
                    .responseJSON { (request, response, data, error) in
                        if(error != nil) {
                            println(error)
                        } else {
                            var fetchedStops = data!.valueForKey("items") as NSArray
                            for stop in fetchedStops {
                                var busStop = NSEntityDescription.insertNewObjectForEntityForName("BusStop", inManagedObjectContext: self.managedObjectContext!) as BusStop
                                busStop.line = line
                                busStop.runDirection = runDirection
                                busStop.stopName = stop.valueForKey("display_name") as String
                            }
                            var stopNotification = NSNotification(name: "busStopsFetched", object: nil)
                            self.notificationCenter.postNotification(stopNotification)
                        }
                }
            }
        })

        var runsURL : String = "\(baseAPIUrl)/routes/\(line.routeNumber)/runs/"
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
    }
}