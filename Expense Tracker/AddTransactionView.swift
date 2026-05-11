//
//  AddTransactionView.swift
//  Expense Tracker
//
//  Created by Sofonyas Tilahun on 5/11/26.
//

import Foundation
import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var store: FinanceStore
    @Environment(\.dismiss) var dismiss

    var defaultType: TransactionType = .expense

    @State private var title  = ""
    @State private var amount = ""
    @State private var type: TransactionType = .expense
    @State private var showError = false

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
                    TextField("Description (e.g. Lunch, Rent)", text: $title)
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
            .navigationTitle(type == .expense ? "Add Expense" : "Add Income")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .bold()
                }
            }
            .onAppear { type = defaultType }
        }
    }

    private func save() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let value = Double(amount), value > 0 else {
            showError = true
            return
        }
        store.addTransaction(Transaction(
            title: title,
            amount: value,
            type: type,
            date: Date()
        ))
        dismiss()
    }
}
