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
    @IBOutlet weak var btnAddPart: UIButton!
    @IBOutlet weak var btnDeleteProj: UIButton!
    @IBOutlet weak var btnEditProj: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private let defaults = UserDefaults.standard
    private var db: OpaquePointer?
    
    private var thisProj: Project = Project(newProjNum: 0, newProjYear: "year", newProjMake: "make", newProjModel: "model")
    private var projectExists = false
    private var partCount = 0
    private var partViewList = [UIView]()
    
    override func viewDidLoad() {
        // Check if key exists in defaults; only needed once
        if (defaults.object(forKey: "projOneExists") == nil) {
            defaults.set(false, forKey: "projOneExists")
        } else {
            self.projectExists = defaults.bool(forKey: "projOneExists")
        }
        createDatabase()
        changeWhatsDisplayed()
        setupPartViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.projectExists = defaults.bool(forKey: "projOneExists")
        changeWhatsDisplayed()
        
    } // end viewDidAppear
    
    func createDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PCBLDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening db")
        }
        
        let query_ProjTable = "CREATE TABLE IF NOT EXISTS project (id INTEGER PRIMARY KEY, year TEXT, make TEXT, model TEXT, partCount INTEGER, distance DOUBLE, totalCost DOUBLE)"
        
        let query_PartTable = "CREATE TABLE IF NOT EXISTS part (id INTEGER PRIMARY KEY, projectID INTEGER, partName TEXT, cost DOUBLE, dateInstalled TEXT, FOREIGN KEY (projectID) REFERENCES project(id))"
        
        if sqlite3_exec(db, query_ProjTable, nil, nil, nil) != SQLITE_OK {
            print("error creating project table")
        }
        if sqlite3_exec(db, query_PartTable, nil, nil, nil) != SQLITE_OK {
            print("error creating part table")
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
                self.partCount = Int(sqlite3_column_int(stmt, 4))
            } else {
                return
            } // end if sqlite_row
            
            let proj1 = Project(newProjNum: 1, newProjYear: year, newProjMake: make, newProjModel: model)
            thisProj = proj1
            self.parent?.navigationItem.title = thisProj.getName()
            
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
                thisProj.addPart(newPart: tempPart)
            } // end while
        } // end if projectExists
    } // end createDatabase()
    
    func setupPartViews() {
        let viewX = 0, viewHeight = 150
        var viewY = 0
        
        // remove all old views first to avoid overlapping
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        // Go through part list for this project and create part views with associated information
        for part in thisProj.getPartList() {
            let tempView = PartView(frame: CGRect(x: viewX, y: viewY, width: Int(self.view.frame.width), height: viewHeight))
            tempView.layer.cornerRadius = 5
            tempView.setName(newName: part.getName())
            tempView.setCost(newCost: String(part.getCost()))
            tempView.setDate(newDate: part.getDate())
            tempView.setPartNum(newNum: part.getNum())
            partViewList.append(tempView)
            contentView.addSubview(tempView)
            viewY += 150
        }
        
    } // end setupPartViews()
    
    func saveNewProject(year: String, make: String, model: String, update: Bool = false, partCount: Int = 0, distance: Int = 0) {
        self.parent?.navigationItem.title = year + " " + make + " " + model
        // default to not updating if paremeter not provided
        var stmt: OpaquePointer?
        if update {
            let query_UpdateProject = "UPDATE project SET year = ?, make = ?, model = ?, partCount = ?, distance = ?"
            // prepare and make sure the query is okay
            if sqlite3_prepare_v2(db, query_UpdateProject, -1, &stmt, nil) != SQLITE_OK {
                print("error preparing update")
                return
            }
        } else {
            let query_InsertProject = "INSERT INTO project (id, year, make, model, partCount, distance) VALUES (1, ?, ?, ?, 0, 0.0)"
            // prepare and make sure the query is okay
            if sqlite3_prepare_v2(db, query_InsertProject, -1, &stmt, nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert into project: \(err)")
                return
            }
        } // end setting of query
            
        // bind parameters to ? in query above
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self) // keeps variable instead of overwriting it *VERY IMPORTANT*
        if sqlite3_bind_text(stmt, 1, year, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            print("failure binding year")
        }
        if sqlite3_bind_text(stmt, 2, make, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            print("failure binding make")
        }
        if sqlite3_bind_text(stmt, 3, model, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            print("failure binding model")
        }
        if update {
            // TODO: update distance with provided parameters
            if sqlite3_bind_int(stmt, 4, Int32(thisProj.getPartList().count)) != SQLITE_OK {
                print("failure binding partCount")
            }
        }
 
        print()
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            if update {
                print ("failure updating project: \(err)")
            } else {
                print ("failure inserting project: \(err)")
            }
            return
        }
        
        defaults.setValue(true, forKey: "projOneExists")
        self.projectExists = true
        thisProj.setYear(newYear: year)
        thisProj.setMake(newMake: make)
        thisProj.setModel(newModel: model)
        changeWhatsDisplayed()
    } // end saveNewProject()
    
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
                self.saveNewProject(year: alertControl.textFields![0].text ?? "Project 1", make: alertControl.textFields![1].text ?? "", model: alertControl.textFields![2].text ?? "")
                
            } ))
            self.present(alertControl, animated: true, completion: nil)
            return
        } // end guard
        
    } // end openNewProject()
    
    @IBAction func editProject(_ sender: Any) {
        
        let alertControl = UIAlertController(title: "Edit Project", message: nil, preferredStyle: .alert)
        
        alertControl.addTextField()
        alertControl.addTextField()
        alertControl.addTextField()
        
        alertControl.textFields![0].placeholder = "Year"
        alertControl.textFields![0].text = thisProj.getYear()
        alertControl.textFields![1].placeholder = "Make"
        alertControl.textFields![1].text = thisProj.getMake()
        alertControl.textFields![2].placeholder = "Model"
        alertControl.textFields![2].text = thisProj.getModel()
        
        // Doesn't save input
        alertControl.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        // Calls function to handle the input
        alertControl.addAction(UIAlertAction(title: "Accept", style: .default, handler: {action in
            
            // calls function with parameters taken from their respective text fields. Defaults to empty string if box contains nothing
            print("p3: \(self.partCount), \(self.thisProj.getPartCount())")
            self.saveNewProject(year: alertControl.textFields![0].text ?? "", make: alertControl.textFields![1].text ?? "", model: alertControl.textFields![2].text ?? "", update: true, partCount: self.thisProj.getPartCount())
        } ))
        self.present(alertControl, animated: true, completion: nil)
        return
        
    }
    
    
    @IBAction func addNewPart(_ sender: Any) {
        // very similar to add new project
        
        let alertControl = UIAlertController(title: "Add new part", message: nil, preferredStyle: .alert)
        
        alertControl.addTextField()
        alertControl.addTextField()
        alertControl.addTextField()
        
        alertControl.textFields![0].placeholder = "Name"
        alertControl.textFields![1].placeholder = "Cost"
        alertControl.textFields![2].placeholder = "Date"
        
        // Doesn't save input
        alertControl.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        // Calls function to handle the input
        alertControl.addAction(UIAlertAction(title: "Accept", style: .default, handler: {action in
            
            // calls function with parameters taken from their respective text fields. Defaults to empty string if box contains nothing
            self.partCount += 1
            self.saveNewPart(id: self.partCount, name: alertControl.textFields![0].text ?? "", cost: alertControl.textFields![1].text ?? "0.00", date: alertControl.textFields![2].text ?? "")
        } ))
        self.present(alertControl, animated: true, completion: nil)
        
        
    } // end addNewPart()
    
    func saveNewPart(id: Int, name: String, cost: String, date: String, update: Bool = false) {
        // default to not updating if paremeter not provided
        
        var stmt: OpaquePointer?
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self) // keeps variable instead of overwriting it *VERY IMPORTANT*
        if update {
            let query_UpdatePart = "UPDATE part SET id = ?, partName = ?, cost = ?, dateInstalled = ? WHERE projectID = 1"
            // prepare and make sure the query is okay
            if sqlite3_prepare_v2(db, query_UpdatePart, -1, &stmt, nil) != SQLITE_OK {
                print("error preparing update")
                return
            }
            if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding part id: \(err)")
            }
            if sqlite3_bind_text(stmt, 3, name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(err)")
            }
            if sqlite3_bind_text(stmt, 4, cost, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding cost: \(err)")
            }
            if sqlite3_bind_text(stmt, 5, date, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding date: \(err)")
            }
        } else { // not update
            let query_InsertPart = "INSERT INTO part (id, projectID, partName, cost, dateInstalled) VALUES (?, ?, ?, ?, ?)" // ?'s: partNum, projectID, partName, cost, date
            
            // prepare and make sure the query is okay
            if sqlite3_prepare_v2(db, query_InsertPart, -1, &stmt, nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert into part: \(err)")
                return
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding part id when inserting part: \(err)")
            }
            if sqlite3_bind_int(stmt, 2, 1) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding project id when inserting part: \(err)")
            }
            if sqlite3_bind_text(stmt, 3, name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name when inserting part: \(err)")
            }
            if sqlite3_bind_text(stmt, 4, cost, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding cost when inserting part: \(err)")
            }
            if sqlite3_bind_text(stmt, 5, date, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print("failure binding date when inserting part: \(err)")
            }
        } // end setting of query
 
        print()
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            if update {
                print ("failure updating part: \(err)")
            } else {
                print ("failure inserting part: \(err)")
            }
            return
        }
        // y value is based on id and decremented to get the 0 position
        let tempView = PartView(frame: CGRect(x: 16, y: (id - 1) * 150, width: Int(self.view.frame.width) - 32, height: 150))
        tempView.layer.cornerRadius = 5
        tempView.setName(newName: name)
        tempView.setCost(newCost: String(cost))
        tempView.setDate(newDate: date)
        tempView.setPartNum(newNum: id)
        tempView.bounds.size.width = view.bounds.size.width
        tempView.bounds.size.height = 150
        
        partViewList.append(tempView)
        contentView.addSubview(tempView)
        
        let tempPart = Part(newNum: id, newName: name, newCost: Double(cost) ?? 0.00, newDate: date)
        thisProj.addPart(newPart: tempPart)
        // update partCount (id) in table; updated when this function is called
        self.saveNewProject(year: thisProj.getYear(), make: thisProj.getMake(), model: thisProj.getModel(), update: true, partCount: self.partCount)
        
    } // end saveNewPart()
    
    @IBAction func deleteSelected(_ sender: Any) {
        let alertControl = UIAlertController(title: "Delete Project", message: nil, preferredStyle: .alert)
        
        alertControl.message = "Are you sure you want to delete this project?"
        alertControl.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // Calls function
        alertControl.addAction(UIAlertAction(title: "Accept", style: .destructive, handler: {action in
            self.deleteProject()
        }))
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func deleteProject() {
        // All parts for project must be deleted before project can be deleted
        var stmt: OpaquePointer?
        if (thisProj.getPartList().count > 0) {
            for i in 1 ... thisProj.getPartCount() {
                deletePart(partNum: i)
            }
        }
        
        let query_DeleteProjectEntry = "DELETE FROM project WHERE id = 1"
        
        if sqlite3_prepare(db, query_DeleteProjectEntry, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing project delete statement: \(err)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting project 1: \(err)")
            return
        }
                
        defaults.setValue(false, forKey: "projOneExists")
        projectExists = false
        self.parent?.navigationItem.title = "Project 1"
        changeWhatsDisplayed()
        thisProj.clearPartsList()
        partCount = 0

        // Remove all views
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
    } // end deleteProject
    
    func deletePart(partNum: Int) {
        // Deletes part with provided number from project 1
        
        var stmt: OpaquePointer?
        let query_DeletePart = "DELETE FROM part WHERE id = ? AND projectID = 1"
        
        if sqlite3_prepare(db, query_DeletePart, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing part delete statement: \(err)")
            return
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(partNum)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("failure binding part id: \(err)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting part \(partNum): \(err)")
            return
        }
        
    } // end deletePart
    
    func changeWhatsDisplayed () {
        if projectExists {
            btnNewProj.isHidden = true
            btnAddPart.isHidden = false
            btnDeleteProj.isHidden = false
            btnEditProj.isHidden = false
            scrollView.isHidden = false
        } else {
            btnNewProj.isHidden = false
            btnAddPart.isHidden = true
            btnDeleteProj.isHidden = true
            btnEditProj.isHidden = true
            scrollView.isHidden = true
        }
    }
    
}
