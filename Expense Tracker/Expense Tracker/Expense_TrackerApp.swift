import SwiftUI

@main
struct Expense_TrackerApp: App {
    @StateObject private var store = FinanceStore()
    @State private var showAddSheet = false

    var body: some Scene {
        WindowGroup {
            if store.hasOnboarded {
                MainTabView()
                    .environmentObject(store)
                    .sheet(isPresented: $showAddSheet) {
                        AddTransactionView(defaultType: .expense)
                            .environmentObject(store)
                    }
                    .onOpenURL { url in
                        if url.host == "add" {
                            showAddSheet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showAddSheet = true
                            }
                        }
                    }
            } else {
                OnboardingView()
                    .environmentObject(store)
            }
        }
    }
}
