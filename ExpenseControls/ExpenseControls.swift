import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Add Expense Control
struct AddExpenseControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.sofonyas.expensetracker.addExpense"
        ) {
            ControlWidgetButton(action: OpenAddExpenseIntent()) {
                Label("Add Expense", systemImage: "minus.circle.fill")
            }
        }
        .displayName("Add Expense")
        .description("Quickly log an expense.")
    }
}

// MARK: - Add Income Control
struct AddIncomeControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.sofonyas.expensetracker.addIncome"
        ) {
            ControlWidgetButton(action: OpenAddIncomeIntent()) {
                Label("Add Income", systemImage: "plus.circle.fill")
            }
        }
        .displayName("Add Income")
        .description("Quickly log income.")
    }
}

// MARK: - Intents
struct OpenAddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Expense"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }

    static var openAppWhenRun_url: URL? {
        URL(string: "expensetracker://addexpense")
    }
}

struct OpenAddIncomeIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Income"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }

    static var openAppWhenRun_url: URL? {
        URL(string: "expensetracker://addincome")
    }
}

// MARK: - Bundle
@main
struct ExpenseControlsBundle: WidgetBundle {
    var body: some Widget {
        AddExpenseControl()
        AddIncomeControl()
    }
}
