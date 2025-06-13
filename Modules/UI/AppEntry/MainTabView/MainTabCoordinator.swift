//
//  MainTabCoordinator.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import SwiftUI
import TransactionsUI
import AccountsUI
import SettingsUI
import CategoriesUI

struct MainTabCoordinator {
    func view(for tab: MainTab) -> AnyView {
        switch tab {
        case .expenses:
            return AnyView(TransactionsListView(direction: .outcome))
        case .incomes:
            return AnyView(TransactionsListView(direction: .income))
        case .accounts:
            return AnyView(AccountsView())
        case .categories:
            return AnyView(CategoriesView())
        case .settings:
            return AnyView(SettingsView())
        }
    }
}
