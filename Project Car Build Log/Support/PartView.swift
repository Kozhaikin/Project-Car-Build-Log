//
//  PartView.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/28/21.
//

import Foundation
import UIKit

class PartView: UIView {
    
    var lblName: UILabel
    var lblCost: UILabel
    var lblDate: UILabel
    var partNum: Int = 0
    let defaults = UserDefaults.standard
    
    override init(frame: CGRect) {
        self.lblName = UILabel(frame: CGRect(x: 8, y: 5, width: frame.width / 2, height: 42))
        self.lblCost = UILabel(frame: CGRect(x: 8, y: 62, width: frame.width / 2, height: 42))
        self.lblDate = UILabel(frame: CGRect(x: 8, y: 118, width: frame.width / 2, height: 42))
        self.lblDate.text = ""
                
        super.init(frame: frame)
        self.addSubview(lblName)
        self.addSubview(lblCost)
        self.addSubview(lblDate)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lblName = UILabel(frame: CGRect(x: 8, y: 8, width: 150, height: 42))
        self.lblCost = UILabel(frame: CGRect(x: 8, y: 65, width: 150, height: 42))
        self.lblDate = UILabel(frame: CGRect(x: 8, y: 121, width: 150, height: 42))
        super.init(coder: aDecoder)
    }
    
    func setName(newName: String) {
        self.lblName.text = newName
    }
    
    func setCost(newCost: String) {
        // get currency symbol from settings and prepend it to provided cost
        if (newCost == "") {
            self.lblCost.text = (defaults.string(forKey: "currency") ?? "$") + "0.00"
        } else {
            self.lblCost.text = (defaults.string(forKey: "currency") ?? "$") + newCost
        }
    }
    
    func setDate(newDate: String) {
        if (newDate == "") {
            self.lblDate.isHidden = true
        } else {
            self.lblDate.text = newDate
        }
    }
    
    func setPartNum(newNum: Int) {
        self.partNum = newNum
    }
    
}
