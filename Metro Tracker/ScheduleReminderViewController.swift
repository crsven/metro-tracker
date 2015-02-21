//
//  ScheduleReminderViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/19/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit

class ScheduleReminderViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var busStop: BusStop!

    @IBOutlet var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 60
        } else {
            return 1
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return "\(row)"
        } else {
            return "minutes"
        }
    }

    @IBAction func reminderScheduled() {
        var busWatcher : BusWatcher = BusWatcher(busStop: busStop, warningTime: pickerView.selectedRowInComponent(0))
        busWatcher.start()
    }
}