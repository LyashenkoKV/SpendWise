//
//  MainTab.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import SwiftUI
import Common

enum MainTab: Int, CaseIterable, Hashable {
    case expenses, incomes, accounts, categories, settings

    var title: LocalizedStringKey {
        switch self {
        case .expenses: return "Расходы"
        case .incomes: return "Доходы"
        case .accounts: return "Счет"
        case .categories: return "Статьи"
        case .settings: return "Настройки"
        }
    }

    var icon: String {
        switch self {
        case .expenses:   return AppIcon.expenses
        case .incomes:    return AppIcon.incomes
        case .accounts:   return AppIcon.account
        case .categories: return AppIcon.categories
        case .settings:   return AppIcon.settings
        }
    }
}
