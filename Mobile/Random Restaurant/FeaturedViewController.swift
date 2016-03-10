//
//  ViewController.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RefreshableViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var restaurant: Restaurant? = nil {
        didSet {
            updateView()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = (segue.destinationViewController as? UINavigationController)?.topViewController as? RestaurantDetailViewController {
            controller.restaurant = restaurant!
        }
    }

    // MARK: - RefreshableViewDelegate

    func configureView() {
        updateView()
    }

    func updateView() {
        let enabled = restaurant != nil
        saveButton.enabled = enabled
        detailButton.enabled = enabled
        if restaurant != nil {
            label.text = restaurant?.name
        } else {
            label.text = ""
        }
    }

    // MARK: - IBActions

    @IBAction func refreshAction(sender: UIBarButtonItem) {
        refresh()
    }

    @IBAction func saveAction(sender: UIBarButtonItem) {
        guard let restaurant = self.restaurant else {
            return
        }
        if let _ = ActivityManager().addActivity(restaurant) {
            let alert = UIAlertController(title: "Confirmed!", message: "Enjoy \(restaurant.name)!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Motion
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            refresh()
        }
    }

    // MARK: - Private Interface

    private func refresh() {
        restaurant = RestaurantRandomizer.getRandomRestaurant(4)
    }


}

