//
//  HistoryView.swift
//  Expense Tracker
//
//  Created by Sofonyas Tilahun on 5/11/26.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var editingTransaction: Transaction? = nil

    var body: some View {
        NavigationStack {
            Group {
                if store.transactions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No transactions yet.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(store.transactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    editingTransaction = transaction
                                }
                        }
                        .onDelete(perform: store.deleteTransaction)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("History")
            .sheet(item: $editingTransaction) { transaction in
                EditTransactionView(transaction: transaction)
                    .environmentObject(store)
            }
        }
    }
}

// ── Edit Transaction Sheet ─────────────────────────────────
struct EditTransactionView: View {
    @EnvironmentObject var store: FinanceStore
    @Environment(\.dismiss) var dismiss

    let transaction: Transaction

    @State private var title: String
    @State private var amount: String
    @State private var type: TransactionType
    @State private var showError = false

    init(transaction: Transaction) {
        self.transaction = transaction
        _title  = State(initialValue: transaction.title)
        _amount = State(initialValue: String(transaction.amount))
        _type   = State(initialValue: transaction.type)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Type") {
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Details") {
                    TextField("Description", text: $title)
                    TextField("Amount (ETB)", text: $amount)
                        .keyboardType(.decimalPad)
                }

                if showError {
                    Section {
                        Text("Please fill in all fields with a valid amount.")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.bold()
                }
            }
        }
    }

    private func save() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let value = Double(amount), value > 0 else {
            showError = true
            return
        }
        store.updateTransaction(Transaction(
            id: transaction.id,
            title: title,
            amount: value,
            type: type,
            date: transaction.date
        ))
        dismiss()
    }
}
