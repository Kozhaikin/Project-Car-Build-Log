//
//  NewProjectWindow.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/20/21.
//

import Foundation
import UIKit

class NewProjectWindow: UIView {
    
    let popUpWindow = UIView(frame: CGRect.zero) // the window itself
    let title = UILabel(frame: CGRect.zero) // Text: Create a new project
    let lblYear = UILabel(frame: CGRect.zero) // Text: "Year: "
    let txtYear = UITextField(frame: CGRect.zero) // Text Field for year input
    let lblMake = UILabel(frame: CGRect.zero) // Text: "Make: "
    let txtMake = UITextField(frame: CGRect.zero) // Text Field for make input
    let lblModel = UILabel(frame: CGRect.zero) // Text: "Model: "
    let txtModel = UITextField(frame: CGRect.zero) // Text Field for model input
    let btnOkay = UIButton(frame: CGRect.zero) // accept button
    let btnCancel = UIButton(frame: CGRect.zero) // cancel button

    init() {
        super.init(frame: CGRect.zero)
        
        // area around window; semi-transparent
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        popUpWindow.backgroundColor = UIColor.systemBlue
        title.textColor = UIColor.label
        title.textAlignment = .center
        lblYear.textColor = UIColor.label
        lblMake.textColor = UIColor.label
        //lblModel.textColor = UIColor.label
        btnCancel.setTitleColor(UIColor.red, for: .normal)
        
        addSubview(popUpWindow)
        
        // Colors can be seen at https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
