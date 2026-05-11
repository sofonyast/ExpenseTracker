<div align="center">

# 💰 Expense Tracker
### A clean, minimal personal finance app for iOS — built with SwiftUI

![iOS](https://img.shields.io/badge/iOS-18%2B-black?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-16%2B-147EFB?style=for-the-badge&logo=xcode&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

*Track your income, log your expenses, and always know where your money goes.*

---

</div>

## ✨ Features

| Feature | Description |
|---|---|
| 💼 **Balance Setup** | Set your starting balance on first launch — or skip and start at zero |
| ➕ **Add Transactions** | Log expenses and income with a description and amount in seconds |
| 📋 **Transaction History** | View a full list of every transaction you've made |
| ✏️ **Edit & Delete** | Tap any transaction to edit it, or swipe to delete |
| 📊 **Spending Chart** | Visual bar chart showing your income vs expenses over time |
| 🔄 **Reset All Data** | Wipe everything and start fresh with one tap |
| 🏠 **Home Screen Widget** | See your balance and add transactions right from your home screen |
| 🌗 **Light & Dark Mode** | Fully supports both iOS appearance modes |
| 💾 **Persistent Storage** | All data is saved locally — survives app restarts and reboots |

---

## 📱 Screenshots

> *Add your screenshots here after running the app*

| Dashboard | Add Transaction | History | Chart |
|---|---|---|---|
| ![Dashboard](screenshots/dashboard.png) | ![Add](screenshots/add.png) | ![History](screenshots/history.png) | ![Chart](screenshots/chart.png) |

---

## 🗂️ Project Structure

```
Expense Tracker/
│
├── 📁 Expense Tracker/
│   ├── Expense_TrackerApp.swift      # App entry point + deep link handling
│   ├── Models.swift                  # Transaction model + FinanceStore
│   ├── MainTabView.swift             # Root tab navigation
│   ├── OnboardingView.swift          # First-launch balance setup
│   ├── DashboardView.swift           # Home screen with balance card
│   ├── AddTransactionView.swift      # Add expense or income sheet
│   ├── HistoryView.swift             # Full transaction list + edit
│   ├── ChartView.swift               # Spending bar chart
│   └── Assets.xcassets               # App icon + colors
│
└── 📁 BalanceWidget/
    └── BalanceWidget.swift           # Home screen widget
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│                  SwiftUI Views               │
│  Dashboard  │  History  │  Chart  │  Widget  │
└──────────────────┬──────────────────────────┘
                   │ @EnvironmentObject
                   ▼
┌─────────────────────────────────────────────┐
│              FinanceStore                    │
│         (ObservableObject)                   │
│                                             │
│  + transactions: [Transaction]              │
│  + currentBalance: Double                   │
│  + addTransaction()                         │
│  + deleteTransaction()                      │
│  + updateTransaction()                      │
│  + resetAll()                               │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         UserDefaults (App Group)             │
│   group.com.sofonyas.expensetracker          │
│                                             │
│   Shared between main app + widget          │
└─────────────────────────────────────────────┘
```

---

## 🚀 Getting Started

### Prerequisites

- Mac with **Xcode 16+**
- iPhone running **iOS 18+**
- Free Apple ID (for running on your own device)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/expense-tracker-ios.git
   cd expense-tracker-ios
   ```

2. **Open in Xcode**
   ```bash
   open "Expense Tracker.xcodeproj"
   ```

3. **Set your development team**
   - Click the project → **Signing & Capabilities**
   - Select your Apple ID under **Team**
   - Do the same for the **BalanceWidget** target

4. **Set up App Groups** *(required for widget)*
   - Both `Expense Tracker` and `BalanceWidget` targets need the App Group:
     `group.com.sofonyas.expensetracker`

5. **Run the app**
   - Select your iPhone from the device list
   - Press `⌘ + R`

---

## 🧩 Home Screen Widget

The app includes a **BalanceWidget** that lives on your home screen.

### How to add it:
1. Long press your home screen → tap **"+"**
2. Search for **"Expense Tracker"**
3. Choose **Small** or **Medium** size
4. Tap **Add Widget**

### What it shows:
- 💰 Your **current balance**
- 📉 Total **amount spent**
- ➕ A tap button that opens the **Add Transaction** sheet instantly

> The widget refreshes automatically every time you add a transaction inside the app.

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **SwiftUI** | All UI — declarative, reactive views |
| **Swift Charts** | Bar chart for spending visualization |
| **UserDefaults** | Local data persistence (via JSON encoding) |
| **WidgetKit** | Home screen balance widget |
| **App Groups** | Shared storage between app and widget |
| **AppIntents** | Deep link handling from widget |
| **Combine** | Reactive data flow via `ObservableObject` |

---

## 📦 Data Model

```swift
struct Transaction: Identifiable, Codable {
    var id: UUID
    var title: String       // "Lunch", "Rent", "Salary"
    var amount: Double      // 150.00
    var type: TransactionType  // .expense or .income
    var date: Date
}

enum TransactionType: String, Codable {
    case expense = "Expense"
    case income  = "Income"
}
```

---

## 🎨 Design Decisions

- **No categories** — kept intentionally simple for daily personal use
- **UserDefaults over Core Data** — sufficient for personal transaction lists, zero setup overhead
- **Single "Add Transaction" button** — you choose expense or income inside the sheet, reducing cognitive load
- **ETB currency** — configured for Ethiopian Birr; change `"ETB"` to any ISO currency code in the source files to adapt
- **Cream / green palette** — clean and easy on the eyes in both light and dark mode

---

## 🔧 Customization

### Change the currency
Search for `"ETB"` across all Swift files and replace with your preferred ISO currency code (e.g. `"USD"`, `"EUR"`, `"GBP"`).

### Change the App Group identifier
If you fork this project, replace `group.com.sofonyas.expensetracker` with your own identifier in:
- `Models.swift`
- `BalanceWidget.swift`
- Both targets' **Signing & Capabilities → App Groups**

---

## 🗺️ Roadmap

- [ ] iCloud sync across devices
- [ ] Budget limits with alerts
- [ ] Export transactions as CSV
- [ ] Recurring transactions
- [ ] Face ID / passcode lock
- [ ] Multiple currencies

---

## 👨‍💻 Built By

**Sofonyas Tilahun**
Founder & Developer @ [Pixel Creatives](https://github.com/yourusername)

> Built from scratch in a single session using SwiftUI, guided step by step.

---

## 📄 License

```
MIT License

Copyright (c) 2026 Sofonyas Tilahun

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.
```

---

<div align="center">

Made with ❤️ in Addis Ababa, Ethiopia 🇪🇹

⭐ Star this repo if you found it useful!

</div>
