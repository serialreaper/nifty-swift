//
//  FindRecord.swift
//  Nifty
//
//  Created by Mac-LAB on 11/5/26.
//

import Foundation
import SwiftData

@Model
final class FindRecord {
    @Attribute(.unique) var id: UUID
    var findName: String
    var price: Double
    var storeName: String
    var brand: String
    var conditionRaw: String
    var issues: String
    var repairNotes: String
    var personalNotes: String
    var statusRaw: String
    var createdAt: Date

    /// Photos are stored as separate files by SwiftData, which keeps the database small and fast.
    @Attribute(.externalStorage) var imageData: Data?

    init(from find: Find, createdAt: Date = Date()) {
        self.id = find.id
        self.findName = find.findName
        self.price = find.price
        self.storeName = find.storeName
        self.brand = find.brand
        self.conditionRaw = find.condition.rawValue
        self.issues = find.issues
        self.repairNotes = find.repairNotes
        self.personalNotes = find.personalNotes
        self.statusRaw = find.status.rawValue
        self.imageData = find.image
        self.createdAt = createdAt
    }

    /// Copies the editable values of a Find into this record (id and createdAt never change).
    func apply(_ find: Find) {
        findName = find.findName
        price = find.price
        storeName = find.storeName
        brand = find.brand
        conditionRaw = find.condition.rawValue
        issues = find.issues
        repairNotes = find.repairNotes
        personalNotes = find.personalNotes
        statusRaw = find.status.rawValue
        imageData = find.image
    }

    /// Converts the stored record back into the Find struct used by the views.
    var asFind: Find {
        Find(
            id: id,
            findName: findName,
            price: price,
            storeName: storeName,
            brand: brand,
            condition: FindCondition(rawValue: conditionRaw) ?? .good,
            issues: issues,
            repairNotes: repairNotes,
            personalNotes: personalNotes,
            status: FindStatus(rawValue: statusRaw) ?? .considering,
            image: imageData
        )
    }
}
