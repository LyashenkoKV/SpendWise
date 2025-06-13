//
//  Networking.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 06.06.2025.
//

import Foundation
import Domain

public final class CategoriesServiceMock {
    public init() {}

    public func getMockCategories() async throws -> [ExpensesCategory] {
        [
            ExpensesCategory(id: 1, name: "Зэпэшэчька", emoji: "💵", isIncome: true),
            ExpensesCategory(id: 2, name: "Еда", emoji: "🥟", isIncome: false)
        ]
    }

    public func getMockListCategories(direction: Direction) async throws -> [ExpensesCategory] {
        try await getMockCategories().filter { $0.direction == direction }
    }
}
