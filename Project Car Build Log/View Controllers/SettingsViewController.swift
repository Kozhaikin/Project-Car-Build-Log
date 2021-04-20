//
//  SettingsViewController.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
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
        // TODO: Read saved settings and update selection accordingly
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
    }
    
    func save() {
        
    }
    
    
}
