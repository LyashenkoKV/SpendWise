//
//  TransactionsServiceMock.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation
import Domain

public actor TransactionsServiceMock {

    private var mockTransactions: [Transaction] = [
        Transaction(
            id: 1,
            accountId: 1,
            categoryId: 1,
            amount: 500,
            transactionDate: Date(),
            comment: "Тест",
            createdAt: Date(),
            updatedAt: Date()
        )
    ]

    public init() {}

    public func getTransactions(for accountId: Int, from start: Date, to end: Date) async throws -> [Transaction] {
        mockTransactions.filter { $0.accountId == accountId && $0.transactionDate >= start && $0.transactionDate <= end }
    }

    public func create(_ transaction: Transaction) async throws {
        mockTransactions.append(transaction)
    }

    public func update(_ transaction: Transaction) async throws {
        if let index = mockTransactions.firstIndex(where: { $0.id == transaction.id }) {
            mockTransactions[index] = transaction
        }
    }

    public func delete(id: Int) async throws {
        mockTransactions.removeAll { $0.id == id }
    }
}
