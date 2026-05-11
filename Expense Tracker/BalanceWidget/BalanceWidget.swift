import WidgetKit
import SwiftUI

struct WidgetData {
    static func load() -> (balance: Double, expenses: Double) {
        let defaults = UserDefaults(suiteName: "group.com.sofonyas.expensetracker") ?? .standard
        let initialBalance = defaults.double(forKey: "initialBalance")

        var transactions: [WidgetTransaction] = []
        if let data = defaults.data(forKey: "transactions"),
           let decoded = try? JSONDecoder().decode([WidgetTransaction].self, from: data) {
            transactions = decoded
        }

        let income   = transactions.filter { $0.type == "Income"  }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
        let balance  = initialBalance + income - expenses
        return (balance, expenses)
    }
}

struct WidgetTransaction: Codable {
    var amount: Double
    var type: String
}

struct BalanceEntry: TimelineEntry {
    let date: Date
    let balance: Double
    let expenses: Double
}

struct BalanceProvider: TimelineProvider {
    func placeholder(in context: Context) -> BalanceEntry {
        BalanceEntry(date: Date(), balance: 15000, expenses: 3200)
    }

    func getSnapshot(in context: Context, completion: @escaping (BalanceEntry) -> Void) {
        let data = WidgetData.load()
        completion(BalanceEntry(date: Date(), balance: data.balance, expenses: data.expenses))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BalanceEntry>) -> Void) {
        let data  = WidgetData.load()
        let entry = BalanceEntry(date: Date(), balance: data.balance, expenses: data.expenses)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

struct BalanceWidgetView: View {
    let entry: BalanceEntry

    var body: some View {
        Link(destination: URL(string: "expensetracker://add")!) {
            VStack(alignment: .leading, spacing: 8) {

                HStack {
                    Image(systemName: "wallet.bifold.fill")
                        .foregroundStyle(.green)
                    Text("Expense Tracker")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                Spacer()

                Text(entry.balance, format: .currency(code: "ETB"))
                    .font(.system(size: 28, weight: .bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text("Spent: \(entry.expenses.formatted(.currency(code: "ETB")))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("＋ Add Transaction")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.green.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.green)
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BalanceProvider()) { entry in
            BalanceWidgetView(entry: entry)
        }
        .configurationDisplayName("Expense Tracker")
        .description("See your balance and add transactions.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct BalanceWidgetBundle: WidgetBundle {
    var body: some Widget {
        BalanceWidget()
    }
}
