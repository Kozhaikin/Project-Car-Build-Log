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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lblName = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
    }
    
    func setName(newName: String) {
        lblName.text = newName
    }
    
}
