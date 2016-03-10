//
//  RestaurantMasterViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/7/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import UIKit
import CoreData

class RestaurantMasterViewController: UITableViewController, RefreshableViewDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    var searchController = UISearchController()
    var restaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()
    var standardLeftItems = [UIBarButtonItem]()
    var editingLeftItems = [UIBarButtonItem]()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let controller = (segue.destinationViewController as? UINavigationController)?.topViewController as? RestaurantDetailViewController {
            controller.restaurant = searchController.active ? filteredRestaurants[indexPath.row] : restaurants[indexPath.row]
        }
    }

    // MARK: - TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? filteredRestaurants.count : restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")!
        let restaurant = searchController.active ? filteredRestaurants[indexPath.row] : restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = (restaurant.activities.count > 0) ? "\(restaurant.activities.count)" : ""
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var restaurants = searchController.active ? filteredRestaurants : self.restaurants
        let restaurant = restaurants[indexPath.row]
        if editingStyle == .Delete {
            RestaurantManager().deleteRestaurant(restaurant.name)
            self.restaurants.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let visitAction = UITableViewRowAction(style: .Normal, title: "Visit") { (action, indexPath) in
            ActivityManager().addActivity(self.restaurants[indexPath.row])
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        return [visitAction]
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.leftBarButtonItems = editing ? editingLeftItems : standardLeftItems
    }

    // MARK: - SelectorActions

    func addAction() {
        let alert = UIAlertController(title: "New Restaurant", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { textfield in
            textfield.placeholder = "Name..."
        }
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { action in
            if let restaurantNameText = alert.textFields?.first?.text where restaurantNameText != "" {
                if let restaurant = RestaurantManager().addRestaurant(restaurantNameText) {
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.restaurants.append(restaurant)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.restaurants.count-1, inSection: 0)], withRowAnimation: .Automatic)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    func sortAction() {
        let alert = UIAlertController(title: nil, message: "Sort", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Name Asc", style: .Default, handler: { action in }))
        alert.addAction(UIAlertAction(title: "Name Desc", style: .Default, handler: { action in }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - UISearchController

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercaseString where searchText != "" {
            filteredRestaurants = restaurants.filter { restaurant -> Bool in
                return restaurant.name.lowercaseString.containsString(searchText)
            }
        } else {
            filteredRestaurants = restaurants
        }
        tableView.reloadData()
    }

    // MARK: - RefreshableViewDelegate

    func configureView() {
        updateView()
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = self.editButtonItem()
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.searchBarStyle = .Minimal
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()

        standardLeftItems = {
            var items = [UIBarButtonItem]()
            items.append(UIBarButtonItem(title: "Sort", style: .Plain, target: self, action: Selector("sortAction")))
            return items
            }()
        editingLeftItems = {
            var items = [UIBarButtonItem]()
            items.append(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addAction")))
            return items
        }()
        navigationItem.leftBarButtonItems = standardLeftItems

        if restaurants.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }

    }

    func updateView() {
        restaurants = RestaurantManager().getAllRestaurants()
        tableView.reloadData()
    }
}