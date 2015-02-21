//
//  BusWatcher.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/19/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit

class BusWatcher : NSObject {
    let metroAPI: MetroAPIService = MetroAPIService()
    var busStop : BusStop
    var warningTime : Int
    var timer : NSTimer = NSTimer()

    init(busStop: BusStop, warningTime: Int) {
        self.busStop = busStop
        self.warningTime = warningTime
    }

    func start() {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "stop", name: "caughtBusNotification", object: nil)

        notificationCenter.addObserverForName("predictionsFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            var predictionDetails : Dictionary<String, Array<Int>> = notification.userInfo! as Dictionary<String, Array<Int>>
            var busesInWindow = [Int]()
            for prediction in predictionDetails["predictions"]! {
                if(prediction <= self.warningTime) {
                    busesInWindow.append(prediction)
                }
            }
            if busesInWindow.count > 0 {
                self.notifyOfBuses(busesInWindow)
            }
            println(busesInWindow)
        })

        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "checkPredictions", userInfo: nil, repeats: false);
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "checkPredictions", userInfo: nil, repeats: true);
    }

    func stop() {
        timer.invalidate()
    }

    func checkPredictions() {
        println("checking predictions")
        metroAPI.fetchPredictionsFor(busStop)
    }

    func notifyOfBuses(buses: [Int]) {
        var localNotification = UILocalNotification()
        localNotification.fireDate = nil

        var alertBody = "Bus"
        if buses.count > 0 {
            alertBody += "es"
        }
        alertBody += " coming in \(buses.first!)"
        for bus in buses {
            alertBody += ", \(bus)"
        }
        alertBody += " minutes"

        localNotification.alertBody = alertBody
        localNotification.alertAction = "View app"
        localNotification.category = "busComingCategory"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}