//
//  RestaurantDetailViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/7/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, RefreshableViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shareAction: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private let dateFormatter = NSDateFormatter()
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - TableView

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.activities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")!
        guard let activity = restaurant.activities[indexPath.row] as? Activity else {
            cell.textLabel?.text = ""
            return cell
        }
        dateFormatter.dateFormat = "EEEE MMM, d"
        cell.textLabel?.text = dateFormatter.stringFromDate(activity.date)
        dateFormatter.dateFormat = "yyyy"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(activity.date)
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let activity = restaurant.activities[indexPath.row] as? Activity else {
            return
        }
        if editingStyle == .Delete {
            if ActivityManager().deleteActivity(activity) {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }

    // MARK: - RefreshableViewDelegate

    func configureView() {
        updateView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func updateView() {
        title = restaurant.name
    }

    // MARK: - IBActions

    @IBAction func shareAction(sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: nil, message: "Actions", preferredStyle: .ActionSheet)
        sheet.addAction(UIAlertAction(title: "Open in Maps", style: .Default, handler: nil))
        if restaurant.activities.count > 0 {
            sheet.addAction(UIAlertAction(title: "Clear All", style: .Destructive, handler: { action in
                let alert = UIAlertController(title: "Clear visit history?", message: "This action cannot be undone", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Clear", style: .Destructive, handler: { action in
                    ActivityManager().deleteAllActivities(forRestaurant: self.restaurant)
                    self.tableView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }))
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(sheet, animated: true, completion: nil)
    }

    @IBAction func doneAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}