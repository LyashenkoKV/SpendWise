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
}
