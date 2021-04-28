//
//  Page1ViewController.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation
import SQLite3
import UIKit

class Page1ViewController: UIViewController {
    
    @IBOutlet weak var btnNewProj: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private let defaults = UserDefaults.standard
    private var db: OpaquePointer?
    
    private var thisProj: Project = Project(newProjNum: 0, newProjYear: "year", newProjMake: "make", newProjModel: "model")
    private var projectExists = false
    private var year: String = ""
    private var make: String = ""
    private var model: String = ""
    private var partCount = 0
    private var partViewList = [UIView]()
    
    override func viewDidLoad() {
        // Check if key exists in defaults; only needed once
        if (defaults.object(forKey: "projOneExists") == nil) {
            defaults.set(false, forKey: "projOneExists")
            save(id: 1, year: "year", make: "make", model: "model", partCount: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createDatabase()
        
        self.projectExists = defaults.bool(forKey: "projOneExists")
        if (projectExists) {
            btnNewProj.isHidden = true
            scrollView.isHidden = false
        } else {
            btnNewProj.isHidden = false
            scrollView.isHidden = true
            // TODO: Finish setting up part views
            //setupPartViews()
            
        } // end if projectExists
        
    } // end viewDidAppear
    
    func createDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PCBLDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening db")
        } else {
            print("database opened")
        }
        
        let query_ProjTable = "CREATE TABLE IF NOT EXISTS project (id INTEGER PRIMARY KEY, year TEXT, make TEXT, model TEXT, partCount INTEGER, distance DOUBLE, totalCost DOUBLE)"
        
        let query_PartTable = "CREATE TABLE IF NOT EXISTS part (id INTEGER PRIMARY KEY AUTOINCREMENT, projectID INTEGER, partName TEXT, cost DOUBLE, dateInstalled TEXT, FOREIGN KEY (projectID) REFERENCES project(id))"
        
        if sqlite3_exec(db, query_ProjTable, nil, nil, nil) != SQLITE_OK {
            print("error creating project table")
        } else {
            print("project table created successfully")
        }
        if sqlite3_exec(db, query_PartTable, nil, nil, nil) != SQLITE_OK {
            print("error creating part table")
        } else {
            print("part table created successfully")
        }
        
        // Read Database Information
        if (projectExists) {
            var year = "", make = "", model = ""
            let query_SelectProjects = "SELECT * FROM project WHERE id = 1"
            
            var stmt: OpaquePointer?
            
            if sqlite3_prepare(db, query_SelectProjects, -1, &stmt, nil) != SQLITE_OK {
                print ("error preparing project statement")
                return
            }
            
            // make sure the row exists
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                year = String(cString: sqlite3_column_text(stmt, 1))
                make = String(cString: sqlite3_column_text(stmt, 2))
                model = String(cString: sqlite3_column_text(stmt, 3))
                title = (year + make + model)
            } else {
                return
            } // end if
            
            let proj1 = Project(newProjNum: 1, newProjYear: year, newProjMake: make, newProjModel: model)
            thisProj = proj1
            
            let query_SelectParts = "SELECT * FROM part WHERE projectID = 1"
            
            if sqlite3_prepare(db, query_SelectParts, -1, &stmt, nil) != SQLITE_OK {
                print("error preparing part statment")
                return
            }
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                // read in info about part, create the object, and add it to the projects part list
                let partNum = sqlite3_column_int(stmt, 0)
                //let projNum = String(cString: sqlite3_column_text(stmt, 1))
                let partName = String(cString: sqlite3_column_text(stmt, 2))
                let partCost = sqlite3_column_double(stmt, 3)
                let partDate = String(cString: sqlite3_column_text(stmt, 4))
                
                let tempPart = Part(newNum: Int(partNum), newName: partName, newCost: partCost, newDate: partDate)
                proj1.addPart(newPart: tempPart)
            } // end while
        } // end if projectExists
    }
    
    func setupPartViews() {
        
        let viewX = 0, viewHeight = 150
        var viewY = 0
        
        for part in thisProj.getPartList() {
            let tempView = UIView(frame: CGRect(x: viewX, y: viewY, width: 0, height: viewHeight))
            partViewList.append(tempView)
            contentView.addSubview(tempView)
            viewY += 150
        }
        
    } // end setupPartViews()
    
    func save(id: Int, year: String, make: String, model: String, partCount: Int){
        
    }
    
    func handleNewProjAction(year: String, make: String, model: String) {
        self.year = year
        self.make = make
        self.model = model
        print(year, make, model)
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
    
}
