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
    let isLast: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.subAppColor)
                        .frame(width: 22)
                    if let emoji = category?.emoji {
                        Text(String(emoji))
                            .font(.system(size: 14.5))
                    }
                }
                .padding(.leading, 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text(category?.name ?? "-")
                        .font(.body)
                    if let comment = transaction.comment, !comment.isEmpty {
                        Text(comment)
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                    }
                }
                Spacer()
                Text("\(transaction.amount, format: .number.precision(.fractionLength(0))) ₽")
                    .font(.body)
                    .foregroundStyle(Color.primaryText)
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondaryText)
            }
            .padding(.trailing, 18)
            .frame(height: 44)

            if !isLast {
                Rectangle()
                    .fill(Color.bgSecondary)
                    .frame(height: 1)
                    .padding(.leading, 54)
                    .padding(.trailing, 0)
                    .alignmentGuide(.bottom) { aligm in aligm[.bottom] }
            }
        }
        .contentShape(Rectangle())
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
        ),
        isLast: false
    )
}
