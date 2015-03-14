//
//  BusStopTableViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/18/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BusStopTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var routeNumber: String = ""
    var busLine : BusLine?
    var busStops = [BusStop]()
    var filteredBusStops = [BusStop]()
    let metroAPIService : MetroAPIService = MetroAPIService()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let notificationCenter = NSNotificationCenter.defaultCenter()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.loadData()
    }

    func loadData() {
        self.loadBusLine()

        notificationCenter.addObserverForName("busStopsFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            self.loadBusStops()
        });
    }

    func loadBusLine() {
        if(busLine == nil || busLine?.routeNumber != routeNumber) {
            let fetchRequest = NSFetchRequest(entityName: "BusLine")
            let predicate = NSPredicate(format: "routeNumber == %@", routeNumber)
            fetchRequest.predicate = predicate
            if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [BusLine] {
                self.busLine = fetchResults.first! as BusLine
                self.loadBusStops()
            }
        } else {
            self.loadBusStops()
        }
    }

    func loadBusStops() {
        let fetchRequest = NSFetchRequest(entityName: "BusStop")
        let predicate = NSPredicate(format: "line == %@", busLine!)
        fetchRequest.predicate = predicate
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [BusStop] {
            if fetchResults.count == 0 {
                metroAPIService.fetchStopsForRoute(busLine!)
            } else {
                self.busStops = fetchResults
                self.tableView.reloadData()
            }
        }
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

        cell.textLabel!.text = "\(busStop.stopName) - \(busStop.runDirection)"
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