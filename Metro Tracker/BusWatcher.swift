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
    var notificationCenter = NSNotificationCenter.defaultCenter()
    var notificationRequest : NotificationRequest
    var predictionObserver : NSObjectProtocol?
    var timer : NSTimer = NSTimer()

    init(notificationRequest: NotificationRequest) {
        self.notificationRequest = notificationRequest
    }

    func start() {
        notificationCenter.addObserver(self, selector: "stop", name: "caughtBusNotification", object: nil)

        notificationCenter.addObserver(self, selector: "checkPredictions", name: "refreshWatcherNotification", object: nil)

        notificationCenter.addObserver(self, selector: "createNotifications:", name: "predictionsFetched", object: nil)

        checkPredictions()
    }

    func createNotifications(notification: NSNotification) {
        var predictionDetails : Dictionary<String, Array<Int>> = notification.userInfo! as Dictionary<String, Array<Int>>
        var busesInWindow = [Int]()
        for var index=0; index < predictionDetails["predictions"]!.count; ++index {
            var prediction = predictionDetails["predictions"]![index]
            if(prediction <= self.notificationRequest.warningTime) {
                busesInWindow.append(prediction)
            }
        }
        if busesInWindow.count > 0 {
            self.notifyOfBuses(&busesInWindow)
        }
        println(busesInWindow)
        println(predictionDetails["predictions"])
        let laterPredictions = predictionDetails["predictions"]!.filter( { (prediction: Int) -> Bool in
            if(contains(busesInWindow, prediction)) {
                return false
            } else {
                return true
            }
        })
        println(laterPredictions)
        if(laterPredictions.count > 0) {
            self.scheduleNotifications(laterPredictions)
        }
    }

    func stop() {
        notificationCenter.removeObserver(self)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func checkPredictions() {
        println("checking predictions")
        metroAPI.fetchPredictionsFor(notificationRequest.routeNumber, stopNumber: notificationRequest.stopNumber)
    }

    func notifyOfBuses(inout buses: [Int]) {
        var localNotification = UILocalNotification()
        localNotification.fireDate = nil

        var alertBody = "Bus"
        if buses.count > 0 {
            alertBody += "es"
        }
        alertBody += " coming in \(buses.first!)"
        let busCount = buses.count
        for bus in buses[1..<busCount] {
            alertBody += ", \(bus)"
        }
        alertBody += " minutes"

        localNotification.alertBody = alertBody
        localNotification.alertAction = "View app"
        localNotification.category = "busComingCategory"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

    func scheduleNotifications(times: [Int]) {
        for time in times {
            var localNotification = UILocalNotification()
            var timeToNotify : Double = Double(time - self.notificationRequest.warningTime)
            var interval = NSTimeInterval(timeToNotify * 60)
            localNotification.fireDate = NSDate(timeIntervalSinceNow: interval)

            var alertBody = "Bus"
            alertBody += " coming in \(self.notificationRequest.warningTime) minutes"

            if(time == times.last) {
                localNotification.category = "finalBusComingCategory"
                alertBody += ". Select \"Keep Watching\" to continue tracking this stop."
            } else {
                localNotification.category = "busComingCategory"
            }
            localNotification.alertBody = alertBody
            localNotification.alertAction = "View app"
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
}