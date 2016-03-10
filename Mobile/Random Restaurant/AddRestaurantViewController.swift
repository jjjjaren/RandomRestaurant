//
//  AddRestaurantViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/7/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import UIKit

class AddRestaurantViewController: UITableViewController, RefreshableViewDelegate {

    var sections = [UIBaseSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default")!
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.value
        cell.textLabel?.enabled = item.enabled
        cell.detailTextLabel?.enabled = item.enabled
        return cell
    }

    // MARK: - RefreshableViewDelegate

    func configureView() {
        let sections = [UIBaseSection]()
        let section = UIBaseSection(title: "New Restaurant", footer: "Restaurant name is required")
        section.items.append(UIBaseItem(identifier: "name", title: "Name", inputType: .Text))
        self.sections = sections
        updateView()
    }

    func updateView() {
        tableView.reloadData()
    }
}