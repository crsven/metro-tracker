//
//  BusStopTableViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/18/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit

class BusStopTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var routeNumber: String = ""
    var busStops = [BusStop]()
    var filteredBusStops = [BusStop]()
    let metroAPIService : MetroAPIService = MetroAPIService()

    override func viewDidLoad() {
        super.viewDidLoad()

//        metroAPIService.fetchStops { (stop: BusStop) in
//            self.busStops.append(stop)
//            self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredBusStops.count
        } else {
            return self.busStops.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var busStop : BusStop
        if tableView == self.searchDisplayController!.searchResultsTableView {
            busStop = self.filteredBusStops[indexPath.row]
        } else {
            busStop = self.busStops[indexPath.row]
        }

//        cell.textLabel!.text = "\(busLine.routeName)"
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    func filterBusLinesForSearchText(searchText: String) {
//        self.filteredBusStops = self.busStops.filter({(busStop: BusStop) -> Bool in
//            let runNameMatch = busStop.routeName.rangeOfString(searchText)
//            let routeNumberMatch = busLine.routeNumber.rangeOfString(searchText)
//            return (runNameMatch != nil || routeNumberMatch != nil)
//        })
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterBusLinesForSearchText(searchString)
        return true
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterBusLinesForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
}