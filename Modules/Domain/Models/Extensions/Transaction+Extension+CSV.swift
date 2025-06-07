//
//  Transaction+Extension+CSV.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation
import Common

public extension Transaction {

    enum CSVField: String, CaseIterable {
       case id,
            accountId,
            categoryId,
            amount,
            transactionDate,
            comment,
            createdAt,
            updatedAt
    }

    static var csvHeader: String {
        CSVField.allCases.map(\.rawValue).joined(separator: ",")
    }

    var csvRow: String {
        CSVField.allCases.map { field in
            switch field {
            case .id: return "\(id)"
            case .accountId: return "\(accountId)"
            case .categoryId: return "\(categoryId)"
            case .amount: return "\(amount)"
            case .transactionDate: return transactionDate.iso8601String
            case .comment: return comment?.replacingOccurrences(of: ",", with: " ") ?? ""
            case .createdAt: return createdAt?.iso8601String ?? ""
            case .updatedAt: return updatedAt?.iso8601String ?? ""
            }
        }.joined(separator: ",")
    }

    init?(csvRow: String) {
        let columns = csvRow.components(separatedBy: ",")
        guard columns.count >= 5 else { return nil }

        func value(_ field: CSVField) -> String { columns[safe: field.index] ?? "" }

        guard
            let id = Int(value(.id)),
            let accountId = Int(value(.accountId)),
            let categoryId = Int(value(.categoryId)),
            let amount = Decimal(string: value(.amount)),
            let transactionDate = Date.fromISO8601(value(.transactionDate))
        else { return nil }
        let comment = value(.comment).nilIfEmpty
        let createdAt = Date.fromISO8601(value(.createdAt))
        let updatedAt = Date.fromISO8601(value(.updatedAt))

        self.init(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    static func toCSV(_ transactions: [Transaction]) -> String {
        ([csvHeader] + transactions.map { $0.csvRow }).joined(separator: "\n")
    }

    static func fromCSV(_ csv: String) -> [Transaction] {
        let lines = csv.components(separatedBy: .newlines).dropFirst()
        return lines.compactMap { Transaction(csvRow: $0) }
    }
}

private extension Transaction.CSVField {
    var index: Int { Self.allCases.firstIndex(of: self)! }
}
