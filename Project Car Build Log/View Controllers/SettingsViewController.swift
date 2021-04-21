//
//  SettingsViewController.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    private let defaults = UserDefaults.standard
    
    private var showDistance: Bool = false
    private var distanceUnit: String = "mi"
    private var currency: String = "$"
    private var version: String = "Version 1.0"
    
    @IBOutlet weak var lblShowDistance: UILabel!
    @IBOutlet weak var swShowDistance: UISwitch!
    @IBOutlet weak var segDistanceUnit: UISegmentedControl! // mi, km
    @IBOutlet weak var segCurrencyUnit: UISegmentedControl! // $, £, €, ¥
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        // check if key-value pairs exist and create if needed else set those saved values to their class variables
        if (defaults.object(forKey: "showDistance") == nil) {
            defaults.set(self.showDistance, forKey: "showDistance")
        } else {
            self.showDistance = defaults.bool(forKey: "showDistance")
        }
        
        if (defaults.object(forKey: "distanceUnit") == nil) {
            defaults.set(self.distanceUnit, forKey: "distanceUnit")
        } else {
            self.distanceUnit = defaults.string(forKey: "distanceUnit") ?? "mi"
            if (self.distanceUnit == "km") {
                self.lblShowDistance.text = "Show Kilometers"
            }
        }
        
        if (defaults.object(forKey: "currency") == nil) {
            defaults.set(self.currency, forKey: "currency")
        } else {
            self.currency = defaults.string(forKey: "currency") ?? "$"
        }

        // read the saved settings and update screen elements
        self.swShowDistance.setOn(self.showDistance, animated: false)
        
        if (self.distanceUnit == "mi") {
            segDistanceUnit.selectedSegmentIndex = 0
        } else {
            segDistanceUnit.selectedSegmentIndex = 1
            self.lblShowDistance.text = "Show Kilometers"
        }
        
        // $, £, €, ¥
        switch (self.currency) {
        case "£":
            segCurrencyUnit.selectedSegmentIndex = 1
            break
        case "€":
            segCurrencyUnit.selectedSegmentIndex = 2
            break
        case "¥":
            segCurrencyUnit.selectedSegmentIndex = 3
            break
        default: // $
            segCurrencyUnit.selectedSegmentIndex = 0
        }
        
        self.lblVersion.text = self.version
    }
    
    @IBAction func updateShowDistance(_ sender: UISwitch) {
        self.showDistance = sender.isOn
        save()
    }
    
    @IBAction func updateDistUnit(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                self.lblShowDistance.text = "Show Miles"
                self.distanceUnit = "mi"
                break
            case 1:
                self.lblShowDistance.text = "Show Kilometers"
                self.distanceUnit = "km"
                break
        default:
            break
        } // end switch
        save()
    }
    
    @IBAction func updateCurrencyUnit(_ sender: UISegmentedControl) {
        // $, £, €, ¥
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.currency = "$"
            break
        case 1:
            self.currency = "£"
            break
        case 2:
            self.currency = "€"
            break
        case 3:
            self.currency = "¥"
            break
        default:
            break
        }
        save()
    }
    
    func save() {
        defaults.set(self.showDistance, forKey: "showDistance")
        defaults.set(self.distanceUnit, forKey: "distanceUnit")
        defaults.set(self.currency, forKey: "currency")
    }
    
    
}
