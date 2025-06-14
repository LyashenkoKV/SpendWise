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
        ZStack(alignment: .bottomTrailing) {
            Color.bgSecondary.ignoresSafeArea()

            VStack(alignment: .leading) {
                Text(
                    viewModel.direction == .income ? TransactionsListTexts.incTitle : TransactionsListTexts.expTitle)
                .font(.largeTitle.bold())
                .padding(.top, 24)
                .padding(.horizontal, 16)

                if case let .loaded(_, total, _) = viewModel.state {
                    HStack {
                        Text(TransactionsListTexts.total)
                            .font(.headline)
                        Spacer()
                        Text("\(total.formattedGrouped) ₽")
                            .font(.headline.bold())
                            .foregroundStyle(Color.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.bgPrimary)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Constants.cornerRadius10,
                            style: .continuous
                        )
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }

                Text(TransactionsListTexts.operations.uppercased())
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                Group {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity
                            )
                    case .error(let message):
                        VStack {
                            Text(TransactionsListTexts.error)
                            Text(message)
                                .font(.caption)
                                .foregroundStyle(Color.bgPrimary)
                            Button(TransactionsListTexts.retry) {
                                Task { await viewModel.load() }
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 8)
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                    case .empty:
                        Text(TransactionsListTexts.empty)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity
                            )
                    case .loaded(let items, _, let categories):
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(items) { transaction in
                                    let category = categories.first(
                                        where: { $0.id == transaction.categoryId
                                        })
                                    TransactionCell(
                                        transaction: transaction,
                                        category: category)
                                    .background(Color.bgPrimary)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: Constants.cornerRadius10,
                                            style: .continuous
                                        )
                                    )
                                    Rectangle()
                                        .fill(Color.bgSecondary)
                                        .frame(height: 1)
                                        .padding(.leading, 54)
                                        .padding(.trailing, 16)
                                }
                                Spacer(minLength: 60)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(action: { /* Действие добавления */ }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.accentAppColor)
                    .clipShape(Circle())
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
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
                    ),
                    TransactionModel(
                        id: 3,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 4,
                        accountId: 1,
                        categoryId: 2,
                        amount: -3000 as Decimal,
                        transactionDate: .now,
                        comment: "Ужин",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 5,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 6,
                        accountId: 1,
                        categoryId: 2,
                        amount: -3000 as Decimal,
                        transactionDate: .now,
                        comment: "Ужин",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 7,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 8,
                        accountId: 1,
                        categoryId: 2,
                        amount: -3000 as Decimal,
                        transactionDate: .now,
                        comment: "Ужин",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 9,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 10,
                        accountId: 1,
                        categoryId: 2,
                        amount: -3000 as Decimal,
                        transactionDate: .now,
                        comment: "Ужин",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 11,
                        accountId: 1,
                        categoryId: 2,
                        amount: -1500 as Decimal,
                        transactionDate: .now,
                        comment: "Ланч",
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    TransactionModel(
                        id: 12,
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
