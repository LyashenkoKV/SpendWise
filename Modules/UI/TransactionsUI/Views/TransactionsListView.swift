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
        NavigationStack {
            content
                .navigationTitle(
                    viewModel.direction == .income ?
                    TransactionsListTexts.incTitle :
                        TransactionsListTexts.expTitle
                )
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { // TODO: - переход на экран "Моя история"
                        }) {
                            Image(systemName: "clock")
                                .foregroundColor(Color.systemText)
                        }
                    }
                }
                .background(Color.bgSecondary)
                .overlay(
                    Button(action: { // TODO: - переход на экран "Создания расхода"
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 21))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.accentAppColor)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                    , alignment: .bottomTrailing
                )

        }
        .onAppear {
            if case .loading = viewModel.state {
                Task { await viewModel.load() }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
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
            SectionedTransactionList(
                items: items,
                total: total,
                categories: categories
            )
        }
    }
}

fileprivate struct SectionedTransactionList: View {
    let items: [TransactionModel]
    let total: Decimal
    let categories: [ExpensesCategory]

    var body: some View {
        List {
            Section {
                HStack {
                    Text(TransactionsListTexts.total)
                        .font(.headline)
                    Spacer()
                    Text("\(total.formattedGrouped) ₽")
                        .font(.headline.bold())
                        .foregroundStyle(Color.secondaryText)
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.bgPrimary)
            }

            Section(header:
                        Text(TransactionsListTexts.operations.uppercased())
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            ) {
                ForEach(items) { transaction in
                    let category = categories.first { $0.id == transaction.categoryId }
                    TransactionCell(transaction: transaction, category: category)
                        .listRowBackground(Color.bgPrimary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.bgSecondary)
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
