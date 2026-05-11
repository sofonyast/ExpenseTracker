//
//  ChartView.swift
//  Expense Tracker
//
//  Created by Sofonyas Tilahun on 5/11/26.
//

import Foundation
import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var store: FinanceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // ── Summary Cards ─────────────────────────
                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "Total In",
                            amount: store.totalIncome + store.initialBalance,
                            color: .green,
                            icon: "arrow.down.circle.fill"
                        )
                        SummaryCard(
                            title: "Total Out",
                            amount: store.totalExpenses,
                            color: .red,
                            icon: "arrow.up.circle.fill"
                        )
                    }
                    .padding(.horizontal)

                    // ── Bar Chart ─────────────────────────────
                    if !store.transactions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Spending Overview")
                                .font(.headline)
                                .padding(.horizontal)

                            Chart(store.transactions) { transaction in
                                BarMark(
                                    x: .value("Date", transaction.date, unit: .day),
                                    y: .value("Amount", transaction.amount)
                                )
                                .foregroundStyle(
                                    transaction.type == .expense ? Color.red.opacity(0.8) : Color.green.opacity(0.8)
                                )
                            }
                            .frame(height: 220)
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        // ── Income vs Expense Summary ─────────
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Breakdown")
                                .font(.headline)

                            HStack {
                                Circle().fill(.green).frame(width: 12, height: 12)
                                Text("Income")
                                Spacer()
                                Text(store.totalIncome, format: .currency(code: "ETB"))
                                    .bold()
                            }
                            Divider()
                            HStack {
                                Circle().fill(.red).frame(width: 12, height: 12)
                                Text("Expenses")
                                Spacer()
                                Text(store.totalExpenses, format: .currency(code: "ETB"))
                                    .bold()
                            }
                            Divider()
                            HStack {
                                Circle().fill(.blue).frame(width: 12, height: 12)
                                Text("Net Balance")
                                Spacer()
                                Text(store.currentBalance, format: .currency(code: "ETB"))
                                    .bold()
                                    .foregroundStyle(store.currentBalance >= 0 ? .green : .red)
                            }
                        }
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.bar.xaxis")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("Add transactions to see your chart.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 60)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .navigationTitle("Charts")
        }
    }
}
