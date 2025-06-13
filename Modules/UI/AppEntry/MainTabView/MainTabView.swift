//
//  MainTabView.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import SwiftUI
import Common

struct MainTabView: View {

    @State private var selectedTab: MainTab = .expenses
    private let coordinator = MainTabCoordinator()

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Tab(
                    value: tab,
                    content: { coordinator.view(for: tab) },
                    label: { Label(tab.title, image: tab.icon) }
                )
            }
        }
        .tint(Color.accentAppColor)
    }
}

#Preview {
    MainTabView()
}
