//
//  MainTabView.swift
//  Expense Tracker
//
//  Created by Sofonyas Tilahun on 5/11/26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }

            ChartView()
                .tabItem {
                    Label("Charts", systemImage: "chart.pie.fill")
                }
        }
    }
}
