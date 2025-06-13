//
//  TransactionsListViewModel.swift
//  TransactionsUI
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import Foundation
import Combine
import Domain
import Networking

// MARK: - State

enum TransactionsListState {
    case loading
    case loaded(items: [TransactionModel], total: Decimal, categories: [ExpensesCategory])
    case empty
    case error(String)
}

@MainActor
public final class TransactionsListViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var state: TransactionsListState = .loading

    // MARK: - Private Properties

    let direction: Direction
    private let transactionsProvider: () async throws -> [TransactionModel]
    private let categoriesProvider: () async throws -> [ExpensesCategory]

    // MARK: - Init

    init(
        direction: Direction,
        transactionsProvider: @escaping () async throws -> [TransactionModel],
        categoriesProvider: @escaping () async throws -> [ExpensesCategory]
    ) {
        self.direction = direction
        self.transactionsProvider = transactionsProvider
        self.categoriesProvider = categoriesProvider
    }

    // MARK: - Method

    func load() async {
        state = .loading
        do {
            let (transactions, categories) = try await (
                transactionsProvider(),
                categoriesProvider()
            )
            let filtered = transactions.filter {
                direction == .income ? $0.amount > 0 : $0.amount < 0
            }
            if filtered.isEmpty {
                state = .empty
            } else {
                let total = filtered.reduce(Decimal(0)) { $0 + $1.amount }
                state = .loaded(items: filtered, total: total, categories: categories)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
