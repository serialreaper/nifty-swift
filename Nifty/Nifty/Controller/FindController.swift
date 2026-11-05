//
//  FindController.swift
//  Nifty
//
//  Created by Mac-LAB on 9/8/26.
//
//  Stage 1: the controller now saves everything to a local SwiftData database.
//  `finds` is reloaded from the database after every change, so what you see
//  on screen is always what is actually stored.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class FindController: ObservableObject {

    // MARK: - Published state

    /// All finds, newest first.
    @Published private(set) var finds: [Find] = []

    /// Set when a database operation fails. ContentView shows it in an alert; set to nil to dismiss.
    @Published var errorMessage: String?

    /// Set only if the database could not be opened at launch.
    @Published private(set) var startupError: String?

    // MARK: - Storage

    private var container: ModelContainer?
    private var context: ModelContext?

    /// - Parameter persistent: `true` for the real app (saved on disk).
    ///   `false` (the default) keeps everything in memory, which is what SwiftUI previews and tests want.
    init(persistent: Bool = false) {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: !persistent)
            let container = try ModelContainer(for: FindRecord.self, configurations: configuration)
            self.container = container
            self.context = container.mainContext
            loadFinds()
        } catch {
            startupError = "Nifty couldn't open its storage. Please restart the app. (\(error.localizedDescription))"
        }
    }

    // MARK: - CRUD

    /// Saves a new find. Returns true if it was stored.
    @discardableResult
    func addFind(_ find: Find) -> Bool {
        guard let context else { return failUnavailable() }
        context.insert(FindRecord(from: find))
        return commit(failureMessage: "Your find couldn't be saved. Please try again.")
    }

    /// Saves changes to an existing find. Returns true if it was stored.
    @discardableResult
    func updateFind(_ find: Find) -> Bool {
        guard let record = record(for: find.id) else {
            errorMessage = "That find could not be found anymore."
            return false
        }
        record.apply(find)
        return commit(failureMessage: "Your changes couldn't be saved. Please try again.")
    }

    /// Deletes a find. Returns true if it was removed.
    @discardableResult
    func deleteFind(_ find: Find) -> Bool {
        guard let context else { return failUnavailable() }
        guard let record = record(for: find.id) else {
            errorMessage = "That find could not be found anymore."
            return false
        }
        context.delete(record)
        return commit(failureMessage: "The find couldn't be deleted. Please try again.")
    }

    // MARK: - Status transitions

    @discardableResult
    func markAsBought(_ find: Find) -> Bool {
        setStatus(.bought, for: find)
    }

    @discardableResult
    func markAsPassed(_ find: Find) -> Bool {
        setStatus(.passed, for: find)
    }

    private func setStatus(_ status: FindStatus, for find: Find) -> Bool {
        guard let record = record(for: find.id) else {
            errorMessage = "That find could not be found anymore."
            return false
        }
        record.statusRaw = status.rawValue
        return commit(failureMessage: "Your decision couldn't be saved. Please try again.")
    }

    // MARK: - Lookups

    /// The latest saved version of a find (useful after it has been edited or its status changed).
    func find(id: UUID) -> Find? {
        finds.first { $0.id == id }
    }

    // MARK: - Derived data for the Dashboard and Finds list

    var consideringFinds: [Find] {
        finds.filter { $0.status == .considering }
    }

    var boughtFinds: [Find] {
        finds.filter { $0.status == .bought }
    }

    var passedFinds: [Find] {
        finds.filter { $0.status == .passed }
    }

    func finds(for filter: FindFilter) -> [Find] {
        switch filter {
        case .all: return finds
        case .considering: return consideringFinds
        case .bought: return boughtFinds
        case .passed: return passedFinds
        }
    }

    var totalConsidering: Int {
        consideringFinds.count
    }

    var totalValueOnHold: Double {
        consideringFinds.reduce(0) { $0 + $1.price }
    }

    var totalSavedByPassing: Double {
        passedFinds.reduce(0) { $0 + $1.price }
    }

    var totalSpentOnBuys: Double {
        boughtFinds.reduce(0) { $0 + $1.price }
    }

    // MARK: - Persistence helpers

    private func loadFinds() {
        guard let context else { return }
        let descriptor = FetchDescriptor<FindRecord>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            finds = try context.fetch(descriptor).map { $0.asFind }
        } catch {
            errorMessage = "Your finds couldn't be loaded. Please restart the app."
        }
    }

    private func record(for id: UUID) -> FindRecord? {
        guard let context else { return nil }
        let descriptor = FetchDescriptor<FindRecord>(
            predicate: #Predicate<FindRecord> { $0.id == id }
        )
        do {
            return try context.fetch(descriptor).first
        } catch {
            return nil
        }
    }

    /// Writes pending changes to disk, then reloads `finds`. On failure, undoes the change and reports it.
    private func commit(failureMessage: String) -> Bool {
        guard let context else { return failUnavailable() }
        do {
            try context.save()
            loadFinds()
            return true
        } catch {
            context.rollback()
            loadFinds()
            errorMessage = failureMessage
            return false
        }
    }

    private func failUnavailable() -> Bool {
        errorMessage = "Storage isn't available right now. Please restart the app."
        return false
    }
}
