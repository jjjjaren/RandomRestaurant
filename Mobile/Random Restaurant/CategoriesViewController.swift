//
//  CategoriesViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/10/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import UIKit

class CategoriesViewController: UITableViewController, RefreshableViewDelegate {

    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    // MARK: - IBAction

    @IBAction func addAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { textfield in
            textfield.placeholder = "Name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { action in
            if let nameText = alert.textFields?.first?.text where nameText != "",
                let category = CategoryManager().addCategory(withName: nameText) {
                    self.categories.insert(category, atIndex: 0)
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")!
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = category.restaurants.count > 0 ? "\(category.restaurants.count)" : ""
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
            let category = categories[indexPath.row]
            CategoryManager().deleteCategory(category)
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    // MARK: - RefreshableViewDelegate

    func configureView() {
        updateView()
    }

    func updateView() {
        categories = CategoryManager().getAllCategories()
        tableView.reloadData()
    }
}