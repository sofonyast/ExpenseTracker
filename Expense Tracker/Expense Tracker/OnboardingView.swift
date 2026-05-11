import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var balanceText = ""
    @State private var showError   = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "wallet.bifold.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text("Welcome to Expense Tracker")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                Text("Optionally enter your starting balance, or skip to begin at zero.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Starting Balance (ETB) — optional")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("e.g. 15000", text: $balanceText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                    .font(.title3)
            }
            .padding(.horizontal)

            if showError {
                Text("Please enter a valid number or leave empty.")
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            VStack(spacing: 12) {
                Button {
                    let amount = Double(balanceText) ?? 0.0
                    if balanceText.isEmpty || amount >= 0 {
                        store.completeOnboarding(balance: amount)
                    } else {
                        showError = true
                    }
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }

                Button {
                    store.completeOnboarding(balance: 0.0)
                } label: {
                    Text("Start with ETB 0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
