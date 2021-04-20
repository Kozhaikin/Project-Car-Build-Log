//
//  Page1ViewController.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation
import UIKit

class Page1ViewController: UIViewController {
    
    @IBOutlet weak var btnNewProj: UIButton!
    
    private var projectExists = false
    private var year: String = ""
    private var make: String = ""
    private var model: String = ""
    
    override func viewDidLoad() {
        // TODO: Check if project exists and populate view accordingly
        
        
    }
    
    @IBAction func openNewProject(_ sender: Any) {
        
        guard (projectExists) else {
            
            let alertControl = UIAlertController(title: "Create New Project", message: nil, preferredStyle: .alert)
            
            alertControl.addTextField()
            alertControl.addTextField()
            alertControl.addTextField()
            
            alertControl.textFields![0].placeholder = "Year"
            alertControl.textFields![1].placeholder = "Make"
            alertControl.textFields![2].placeholder = "Model"
            
            // Doesn't save input
            alertControl.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            // Calls function to handle the input
            alertControl.addAction(UIAlertAction(title: "Accept", style: .default, handler: {action in
                
                // calls function with parameters taken from their respective text fields. Defaults to empty string if box contains nothing
                self.handleNewProjAction(year: alertControl.textFields![0].text ?? "", make: alertControl.textFields![1].text ?? "", model: alertControl.textFields![2].text ?? "")
                
            } ))
            self.present(alertControl, animated: true, completion: nil)
            return
        }
        
    }
    
    func handleNewProjAction(year: String, make: String, model: String) {
        self.year = year
        self.make = make
        self.model = model
        print(year, make, model)
    }
    
    
    
    
}
