//
//  HistoryViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/10/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController, RefreshableViewDelegate {

    var activities = [Activity]()
    var dateFormatter = NSDateFormatter()

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
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        if let controller = segue.destinationViewController as? RestaurantDetailViewController {
            controller.restaurant = activities[indexPath.row].restaurant
        } else if let controller = (segue.destinationViewController as? UINavigationController)?.topViewController as? RestaurantDetailViewController {
            controller.restaurant = activities[indexPath.row].restaurant
        }
    }

    // MARK: - TableVIew

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")!
        let activity = activities[indexPath.row]
        cell.textLabel?.text = activity.restaurant.name
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(activity.date)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let activity = activities[indexPath.row]
            ActivityManager().deleteActivity(activity)
            activities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }


    // MARK: - RefreshableViewDelegate

    func configureView() {
        dateFormatter.dateFormat = "EEEE MMM d, YYYY"
        updateView()
    }

    func updateView() {
        activities = ActivityManager().getAllActivities().reverse()
        tableView.reloadData()
    }

}