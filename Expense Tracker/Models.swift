//
//  Models.swift
//  Expense Tracker
//
//  Created by Sofonyas Tilahun on 5/11/26.
//

import Foundation
import Combine
import SwiftUI
import WidgetKit

// MARK: - Transaction Type
enum TransactionType: String, Codable, CaseIterable {
    case expense = "Expense"
    case income  = "Income"
}

// MARK: - Transaction Model
struct Transaction: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var type: TransactionType
    var date: Date
}

// MARK: - Finance Store (UserDefaults persistence)
class FinanceStore: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var initialBalance: Double = 0.0
    @Published var hasOnboarded: Bool = false

    private let transactionsKey = "transactions"
    private let balanceKey      = "initialBalance"
    private let onboardedKey    = "hasOnboarded"
    private let suiteName       = "group.com.sofonyas.expensetracker"

    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    init() {
        load()
    }

    // MARK: Computed balance
    var currentBalance: Double {
        let income   = transactions.filter { $0.type == .income  }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return initialBalance + income - expenses
    }

    var totalExpenses: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    // MARK: Actions
    func completeOnboarding(balance: Double) {
        initialBalance = balance
        hasOnboarded   = true
        save()
    }

    func addTransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
        save()
    }

    func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
        save()
    }

    func updateTransaction(_ updated: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == updated.id }) {
            transactions[index] = updated
            save()
        }
    }
    func resetAll() {
        transactions   = []
        initialBalance = 0.0
        hasOnboarded   = false
        UserDefaults.standard.removeObject(forKey: transactionsKey)
        UserDefaults.standard.removeObject(forKey: balanceKey)
        UserDefaults.standard.removeObject(forKey: onboardedKey)
    }

    // MARK: Persistence
    private func save() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            sharedDefaults.set(encoded, forKey: transactionsKey)
        }
        sharedDefaults.set(initialBalance, forKey: balanceKey)
        sharedDefaults.set(hasOnboarded,   forKey: onboardedKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func load() {
        hasOnboarded   = sharedDefaults.bool(forKey: onboardedKey)
        initialBalance = sharedDefaults.double(forKey: balanceKey)
        if let data    = sharedDefaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
}
