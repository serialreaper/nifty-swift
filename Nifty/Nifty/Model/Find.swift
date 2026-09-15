//
//  Find.swift
//  Nifty
//
//  Created by Mac-LAB on 9/4/26.
//

import Foundation

// FIND STATUS
enum FindStatus: String, Codable, CaseIterable {
    case considering
    case bought
    case passed
}

// FIND CONDITION
enum FindCondition: String, Codable, CaseIterable {
    case excellent
    case good
    case needsRepair
    case heavilyWorn
}
// FIND FILTER
enum FindFilter: String, CaseIterable {
    case all = "All"
    case considering = "Considering"
    case bought = "Bought"
    case passed = "Passed"
}

// FIND
struct Find : Identifiable, Codable, Hashable {
    let id: UUID
    var findName: String
    var price: Double
    var storeName: String
    var brand: String
    var condition: FindCondition
    var issues: String
    var repairNotes: String
    var personalNotes: String
    var status: FindStatus
    var image: Data?
    
    init(id: UUID = UUID(), findName: String, price: Double, storeName: String, brand: String = "", condition: FindCondition, issues: String = "", repairNotes: String = "", personalNotes: String = "", status: FindStatus, image: Data? = nil) {
        self.id = id
        self.findName = findName
        self.price = price
        self.storeName = storeName
        self.brand = brand
        self.condition = condition
        self.issues = issues
        self.repairNotes = repairNotes
        self.personalNotes = personalNotes
        self.status = status
        self.image = image
    }
}
