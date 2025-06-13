//
//  DomainTests.swift
//  DomainTests
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Testing
@testable import Domain
import Foundation

struct DomainTests {
    @Test func testTransactionJsonRoundtrip() throws {
        let transaction = TransactionModel(
            id: 1,
            accountId: 1,
            categoryId: 2,
            amount: 100.55,
            transactionDate: Date(timeIntervalSince1970: 123456789),
            comment: "Тест",
            createdAt: Date(timeIntervalSince1970: 123456789),
            updatedAt: Date(timeIntervalSince1970: 123456999)
        )

        guard let jsonObject = transaction.jsonObject else {
            #expect(false, "jsonObject вернул nil")
            return
        }
        guard let parsed = TransactionModel.parse(jsonObject: jsonObject) else {
            #expect(false, "parse(jsonObject:) вернул nil")
            return
        }
        #expect(parsed.id == transaction.id)
        #expect(parsed.accountId == transaction.accountId)
        #expect(parsed.categoryId == transaction.categoryId)
        #expect(parsed.amount == transaction.amount)
        #expect(parsed.comment == transaction.comment)
        #expect(abs(parsed.transactionDate.timeIntervalSince1970 - transaction.transactionDate.timeIntervalSince1970) < 0.001)
        #expect(abs(parsed.createdAt!.timeIntervalSince1970 - transaction.createdAt!.timeIntervalSince1970) < 0.001)
        #expect(abs(parsed.updatedAt!.timeIntervalSince1970 - transaction.updatedAt!.timeIntervalSince1970) < 0.001)
    }

    @Test func testTransactionParseInvalid() throws {
        let bad: [String: Any] = [
            "id": "notAnInt",
            "amount": "100",
            "transactionDate": "wrong date"
        ]
        let result = TransactionModel.parse(jsonObject: bad)
        #expect(result == nil)
    }
}
