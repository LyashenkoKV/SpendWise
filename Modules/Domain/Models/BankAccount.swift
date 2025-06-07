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
}
