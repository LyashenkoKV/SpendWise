//
//  TransactionCell.swift
//  TransactionsUI
//
//  Created by Konstantin Lyashenko on 13.06.2025.
//

import SwiftUI
import Domain

struct TransactionCell: View {
    let transaction: TransactionModel
    let category: ExpensesCategory?

    var body: some View {
        HStack(spacing: 12) {
            if let emoji = category?.emoji {
                Text(String(emoji))
                    .font(.title3)
            }
            VStack(alignment: .leading) {
                Text(category?.name ?? "-")
                    .font(.body.bold())
                if let comment = transaction.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                }
            }
            Spacer()
            Text("\(transaction.amount, format: .number.precision(.fractionLength(0))) ₽")
                .font(.body.bold())
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TransactionCell(
        transaction: TransactionModel(
            id: 1,
            accountId: 1,
            categoryId: 2,
            amount: -2500 as Decimal,
            transactionDate: Date.now,
            comment: "Бизнес-ланч",
            createdAt: Date.now,
            updatedAt: Date.now
        ),
        category: ExpensesCategory(
            id: 2,
            name: "Еда",
            emoji: "🥗",
            isIncome: false
        )
    )
}
