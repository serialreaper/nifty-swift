//
//  FindController.swift
//  Nifty
//
//  Created by Mac-LAB on 9/8/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FindController: ObservableObject {
    @Published private(set) var finds: [Find] = []
    
    init(loadSampleData: Bool = true) {
        if loadSampleData {
            finds = FindController.sampleFinds
        }
    }
    
    // MARK: - CRUD
    
    func addFind(_ find: Find) {
        finds.insert(find, at: 0)
        persist()
    }
    
    func updateFind(_ find: Find) {
        guard let index = finds.firstIndex(where: { $0.id == find.id }) else { return }
        finds[index] = find
        persist()
    }
    
    func deleteFind(_ find: Find) {
        finds.removeAll { $0.id == find.id }
        persist()
    }
    
    // MARK: Status transitions
    
    func markAsBought(_ find: Find) {
        setStatus(.bought, for: find)
    }
    
    func markAsPassed(_ find: Find) {
        setStatus(.passed, for: find)
    }
    
    private func setStatus(_ status: FindStatus, for find: Find) {
        guard let index = finds.firstIndex(where: { $0.id == find.id }) else { return }
        finds[index].status = status
        persist()
    }
    
    // MARK: - Derived data for the Dashboard and Finds list
    
    var consideringFinds: [Find] {
        finds.filter { $0.status == .considering }
    }
    
    func finds(for filter: FindFilter) -> [Find] {
        switch filter {
        case .all: return finds
        case .considering: return finds.filter { $0.status == .considering }
        case .bought: return finds.filter { $0.status == .bought }
        case .passed: return finds.filter { $0.status == .passed }
        }
    }
    
    var totalConsidering: Int {
        consideringFinds.count
    }
    
    var totalValueOnHold: Double {
        consideringFinds.reduce(0) { $0 + $1.price }
    }
    
    var totalSavedByPassing: Double {
        finds.filter { $0.status == .passed }.reduce(0) { $0 + $1.price }
    }
    
    var totalSpentOnBuys: Double {
        finds.filter { $0.status == .bought }.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - Persistence hook (future work)
    
    /// Placeholder for saving to local storage. Currently a no-op since the midterm build keeps everything in memory;
    /// this is where a SwiftData/Core Data/JSON write would be triggered in the final project.
    private func persist() {
        // TODO: Final Project - write 'finds' to local database.
    }
}

// MARK: - Sample seed data (mirrors the Figma prototype screens)

extension FindController {
    static let sampleFinds: [Find] = [
        Find(
            findName: "Leopard Camisole Top",
            price: 50,
            storeName: "Iyaman",
            brand: "Uniqlo",
            condition: .good,
            issues: "There are stains and holes.",
            repairNotes: "Wash and sew",
            personalNotes: "I like it so much but I have no money yet.",
            status: .considering
        ),
        Find(
            findName: "Leopard Camisole Top",
            price: 50,
            storeName: "Iyaman",
            brand: "Uniqlo",
            condition: .good,
            issues: "There are stains and holes.",
            repairNotes: "Wash and sew",
            personalNotes: "I like it so much but I have no money yet.",
            status: .considering
        ),
        Find(
            findName: "Leopard Camisole Top",
            price: 50,
            storeName: "Iyaman",
            brand: "Uniqlo",
            condition: .good,
            issues: "There are stains and holes.",
            repairNotes: "Wash and sew",
            personalNotes: "I like it so much but I have no money yet.",
            status: .considering
        ),
        Find(
            findName: "Leopard Camisole Top",
            price: 50,
            storeName: "Iyaman",
            brand: "Uniqlo",
            condition: .good,
            issues: "There are stains and holes.",
            repairNotes: "Wash and sew",
            personalNotes: "I like it so much but I have no money yet.",
            status: .considering
        )
    ]
}
