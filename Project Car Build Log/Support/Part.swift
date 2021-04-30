//
//  Part.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import Foundation

class Part {
    
    private var partNum: Int
    private var partName: String
    private var cost: Double
    private var date: String // optional; default is 00/00/00
    
    init(newNum: Int, newName: String, newCost: Double, newDate: String = "00/00/00") {
        self.partNum = newNum
        self.partName = newName
        self.cost = newCost
        self.date = newDate
    }
    
    // gets and sets
    func getNum() -> Int {
        return self.partNum
    }
    
    func setNum(newNum: Int) {
        // for future implementation of swapping positions of parts
    }
    
    func getCost() -> Double {
        return self.cost
    }
    
    func setCost(newCost: Double) {
        self.cost = newCost
    }
    
    func getDate() -> String {
        return self.date
    }
    
    func setDate(newDate: String) {
        self.date = newDate
    }
    
    func getName() -> String {
        return self.partName
    }
    
    func setName(newName: String) {
        self.partName = newName
    }
    
}
