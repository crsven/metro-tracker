//
//  BusLineTableViewController.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import Foundation
import UIKit

class BusLineTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var busLines = [BusLine]()
    var filteredBusLines = [BusLine]()
    let metroAPIService : MetroAPIService = MetroAPIService()

    override func viewDidLoad() {
        super.viewDidLoad()

        metroAPIService.fetchRoutes { (route: BusLine) in
            self.busLines.append(route)
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
