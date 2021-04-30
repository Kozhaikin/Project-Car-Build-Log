//
//  Project.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation

class Project {
    
    private var projNum: Int
    private var year: String
    private var make: String
    private var model: String
    private var projName: String
    private var parts = [Part]()
    
    init(newProjNum: Int, newProjYear: String, newProjMake: String, newProjModel: String) {
        self.projNum = newProjNum
        self.year = newProjYear
        self.make = newProjMake
        self.model = newProjModel
        
        // Concat individual strings for conveince
        projName = year + " " + make + " " + model
    }
    
    // gets and sets
    func getNum() -> Int {
        return self.projNum
    }
    
    func setNum(newNum: Int) {
        // for future implementation of swapping positions of projects
    }
    
    func getYear() -> String {
        return self.year
    }
    
    func setYear(newYear: String) {
        self.year = newYear
        updateName()
    }
    
    func getMake() -> String {
        return self.make
    }
    
    func setMake(newMake: String) {
        self.make = newMake
        updateName()
    }
    
    func getModel() -> String {
        return self.model
    }
    
    func setModel(newModel: String) {
        self.model = newModel
        updateName()
    }
    
    func getName() -> String {
        return self.projName
    }
    
    func updateName() {
        // auto set; called after at least one parameter is changed
        self.projName = self.year + " " + self.make + " " + self.model
    }
    
    func getPartList() -> [Part] {
        return self.parts
    }
    
    func getPartCount() -> Int {
        return self.parts.count
    }
    
    func addPart(newPart: Part) {
        parts.append(newPart)
    }
    
    func removePart(partNum: Int) {
        parts.remove(at: partNum)
    }
    
    func clearPartsList() {
        parts.removeAll()
    }
    
}
