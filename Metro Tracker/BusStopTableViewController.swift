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

        metroAPIService.fetchStopsForRoute(routeNumber, { (stops: [BusStop]) in
            self.busStops = stops
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("BusStopCell", forIndexPath: indexPath) as UITableViewCell

        var busStop : BusStop
        if tableView == self.searchDisplayController!.searchResultsTableView {
            busStop = self.filteredBusStops[indexPath.row]
        } else {
            busStop = self.busStops[indexPath.row]
        }

        cell.textLabel!.text = "\(busStop.stopName)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    func filterBusStopsForSearchText(searchText: String) {
        self.filteredBusStops = self.busStops.filter({(busStop: BusStop) -> Bool in
            let stopNameMatch = busStop.stopName.rangeOfString(searchText)
            return stopNameMatch != nil
        })
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterBusStopsForSearchText(searchString)
        return true
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterBusStopsForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
}