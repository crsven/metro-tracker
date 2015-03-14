//
//  BusLineTableViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BusLineTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var busLines = [BusLine]()
    var filteredBusLines = [BusLine]()
    let metroAPIService : MetroAPIService = MetroAPIService()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let notificationCenter = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationCenter.addObserverForName("busLinesFetched", object: nil, queue: nil, usingBlock: { (NSNotification notification) in
            self.loadLines()
        });

        self.loadLines()

        if self.busLines.count == 0 {
            metroAPIService.fetchBusLines()
        }

    }

    func loadLines() {
        let fetchRequest = NSFetchRequest(entityName: "BusLine")
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [BusLine] {
            self.busLines = fetchResults
            self.tableView.reloadData()
        }
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
            return self.filteredBusLines.count
        } else {
            return self.busLines.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var busLine : BusLine
        if tableView == self.searchDisplayController!.searchResultsTableView {
            busLine = self.filteredBusLines[indexPath.row]
        } else {
            busLine = self.busLines[indexPath.row]
        }

        cell.textLabel!.text = "\(busLine.routeName)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("busLineSelected", sender: tableView)
    }

    func filterBusLinesForSearchText(searchText: String) {
        self.filteredBusLines = self.busLines.filter({(busLine: BusLine) -> Bool in
            let runNameMatch = busLine.routeName.rangeOfString(searchText)
            let routeNumberMatch = busLine.routeNumber.rangeOfString(searchText)
            return (runNameMatch != nil || routeNumberMatch != nil)
        })
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterBusLinesForSearchText(searchString)
        return true
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterBusLinesForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "busLineSelected" {
            var routeNumber : String
            let senderView = sender as UITableView
            if senderView == self.searchDisplayController!.searchResultsTableView {
                var path = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()
                routeNumber = self.filteredBusLines[path!.row].routeNumber
            } else {
                var path = self.tableView.indexPathForSelectedRow()
                routeNumber = self.busLines[path!.row].routeNumber
            }

            var detailController = segue.destinationViewController as BusStopTableViewController
            detailController.routeNumber = routeNumber
        }
    }
}