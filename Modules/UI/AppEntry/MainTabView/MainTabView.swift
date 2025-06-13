//
//  MainTabView.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: MainTab = .expenses

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Tab(value: tab) {
                    tab.content
                } label: {
                    Label(tab.title, image: tab.icon)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
