//
//  NotificationRequestViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 3/15/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotificationRequestViewController : UIViewController {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var activeBusWatcher: BusWatcher!
    var notificationRequest: NotificationRequest?

    @IBOutlet weak var busLineName: UILabel!
    @IBOutlet weak var busStopName: UILabel!
    @IBOutlet weak var busPredictionList: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLineAndStop()

        if(self.activeBusWatcher != nil) {
            self.activeBusWatcher.stop()
            notificationCenter.removeObserver(self)
        }
        self.activeBusWatcher = BusWatcher(notificationRequest: self.notificationRequest!)
        notificationCenter.addObserver(self, selector: "updateText:", name: "busWatcherUpdated", object: self.activeBusWatcher)
        self.activeBusWatcher.start()

    }

    func updateLineAndStop() {
        self.busLineName.text = self.notificationRequest!.routeNumber
        self.busStopName.text = self.notificationRequest!.stopNumber
    }

    func updateText(notification: NSNotification) {
        var updateDetails : Dictionary<String, Array<Int>> = notification.userInfo! as Dictionary<String, Array<Int>>
        let predictions = updateDetails["predictions"]!
        let busCount = predictions.count

        var busList = ""
        busList += "\(predictions.first!)"
        for prediction in predictions[1..<busCount] {
            busList += ", \(prediction)"
        }

        self.busPredictionList.text = busList
    }
}