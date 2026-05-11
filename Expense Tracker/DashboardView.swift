import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var showAddSheet = false
    @State private var showResetConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── Balance Card ──────────────────────────
                    VStack(spacing: 6) {
                        Text("Current Balance")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                        Text(store.currentBalance, format: .currency(code: "ETB"))
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 36)
                    .background(
                        LinearGradient(
                            colors: [Color.green.opacity(0.85), Color.teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .padding(.horizontal)

                    // ── Income / Expense Summary ──────────────
                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "Income",
                            amount: store.totalIncome + store.initialBalance,
                            color: .green,
                            icon: "arrow.down.circle.fill"
                        )
                        SummaryCard(
                            title: "Expenses",
                            amount: store.totalExpenses,
                            color: .red,
                            icon: "arrow.up.circle.fill"
                        )
                    }
                    .padding(.horizontal)

                    // ── Single Add Button ─────────────────────
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Add Transaction", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal)

                    // ── Recent Transactions ───────────────────
                    if !store.transactions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(store.transactions.prefix(5)) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .navigationTitle("Expense Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showResetConfirm = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
            .alert("Reset Everything?", isPresented: $showResetConfirm) {
                Button("Reset", role: .destructive) { store.resetAll() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will erase all transactions and your balance. This cannot be undone.")
            }
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView(defaultType: .expense)
                    .environmentObject(store)
            }
        }
    }
}

// ── Small reusable summary card ────────────────────────────
struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(amount, format: .currency(code: "ETB"))
                    .font(.subheadline.bold())
            }
            Spacer()
        }
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 14))
    }
}

// ── Single transaction row ─────────────────────────────────
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            Image(systemName: transaction.type == .expense ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.title2)
                .foregroundStyle(transaction.type == .expense ? .red : .green)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline.bold())
                Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text((transaction.type == .expense ? "-" : "+") + transaction.amount.formatted(.currency(code: "ETB")))
                .font(.subheadline.bold())
                .foregroundStyle(transaction.type == .expense ? .red : .green)
        }
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}
