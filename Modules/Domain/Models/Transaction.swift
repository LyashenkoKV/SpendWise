//
//  Transaction.swift
//  AccountsUI
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation

public struct Transaction: Identifiable, Codable, Hashable {
    public let id: Int
    public let accountId: Int
    public let categoryId: Int
    public let amount: Decimal
    public let transactionDate: Date
    public let comment: String?
    public let createdAt: Date?
    public let updatedAt: Date?

    public init(
        id: Int,
        accountId: Int,
        categoryId: Int,
        amount: Decimal,
        transactionDate: Date,
        comment: String?,
        createdAt: Date?,
        updatedAt: Date?
    ) {
        self.id = id
        self.accountId = accountId
        self.categoryId = categoryId
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case id,
             accountId,
             categoryId,
             amount,
             transactionDate,
             comment,
             createdAt,
             updatedAt
    }
}
