//
//  BankAccount.swift
//  AccountsUI
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation

public struct BankAccount: Identifiable, Codable, Hashable {
    public let id: Int
    public let userId: Int?
    public let name: String
    public let balance: Decimal
    public let currency: String
    public let createdAt: Date?
    public let updateAt: Date?

    public init(
        id: Int,
        userId: Int?,
        name: String,
        balance: Decimal,
        currency: String,
        createdAt: Date?,
        updateAt: Date?
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updateAt = updateAt
    }
}
