//
//  TransactionsUI.swift
//  TransactionsUI
//
//  Created by Konstantin Lyashenko on 06.06.2025.
//

import SwiftUI
import Domain
import Common

public struct TransactionsListView: View {

    @StateObject var viewModel: TransactionsListViewModel

    public init(
        direction: Direction,
        transactionsProvider: @escaping () async throws -> [TransactionModel] = { [] },
        categoriesProvider: @escaping () async throws -> [ExpensesCategory] = { [] }
    ) {
        _viewModel = StateObject(
            wrappedValue: TransactionsListViewModel(
                direction: direction,
                transactionsProvider: transactionsProvider,
                categoriesProvider: categoriesProvider
            )
        )
    }

    public init(viewModel: TransactionsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message):
                VStack {
                    Text(TransactionsListTexts.error)
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    Button(TransactionsListTexts.retry) {
                        Task { await viewModel.load() }
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                Text(TransactionsListTexts.empty)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded(let items, let total, let categories):
                VStack(spacing: 0) {
                    HStack {
                        Text(TransactionsListTexts.total)
                            .font(.headline)
                        Spacer()
                        Text("\(total.formattedGrouped) ₽")
                            .font(.headline.bold())
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.bgSecondary)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Constants.cornerRadius10,
                            style: .continuous
                        )
                    )

                    Text(TransactionsListTexts.title.uppercased())
                        .font(.caption)
                        .padding(.horizontal)
                        .padding(.top)

                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(items) { transaction in
                                let category = categories.first(where: { $0.id == transaction.categoryId })
                                TransactionCell(transaction: transaction, category: category)
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            if case .loading = viewModel.state {
                Task { await viewModel.load() }
            }
        }
    }
}

fileprivate extension Decimal {
    var formattedGrouped: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = " "
        return numberFormatter
            .string(
                from: self as NSNumber
            ) ?? "\(self)"
    }
}

#Preview {
    TransactionsListView(
        viewModel: TransactionsListViewModel(
            direction: .outcome,
            transactionsProvider: {
                [
                    TransactionModel(
                        id: 1,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 2,
                        accountId: 1,
                        categoryId: 2,
                        amount: -3000 as Decimal,
                        transactionDate: .now,
                        comment: "Ужин",
                        createdAt: .now,
                        updatedAt: .now
                    )
                ]
            },
            categoriesProvider: {
                [
                    ExpensesCategory(
                        id: 2,
                        name: "Еда",
                        emoji: "🍔",
                        isIncome: false
                    )
                ]
            }
        )
    )
}
