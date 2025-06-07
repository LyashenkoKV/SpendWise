//
//  BankAccountsServiceMock.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation
import Domain
import Common

public final class BankAccountsServiceMock {
    public init() {}

    public func getMockSingleBankAccount() async throws -> BankAccount {
        BankAccount(
            id: 1,
            userId: 1,
            name: "Основной счет",
            balance: 1000,
            currency: GlobalConstants.currencyRUB,
            createdAt: nil,
            updateAt: nil
        )
    }

    public func updateMockChange(account: BankAccount) async throws -> BankAccount {
        account
    }
}

