//
//  Persistence.swift
//  Persistence
//
//  Created by Konstantin Lyashenko on 06.06.2025.
//

import Foundation
import Domain
import Common

public actor TransactionsFileCache {

    // MARK: - Properties

    private(set) var transactions: [TransactionModel]
    private let fileURL: URL

    // MARK: - Init

    public init(fileURL: URL) {
        self.fileURL = fileURL
        self.transactions = []
    }

    public init?(fileName: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.shared.log(
                .error,
                message: "Не найдена директория",
                metadata: ["❌": "TransactionsFileCache"]
            )
            return nil
        }
        let url = dir.appending(path: fileName)
        self.init(fileURL: url)
    }

    // MARK: - Public API

    public func all() -> [TransactionModel] {
        transactions
    }

    public func add(_ transaction: TransactionModel) -> Bool {
        guard !transactions.contains(where: { $0.id == transaction.id }) else { return false }
        transactions.append(transaction)
        return true
    }

    public func delete(by id: Int) -> Bool {
        let before = transactions.count
        transactions.removeAll { $0.id == id }
        return transactions.count < before
    }

    public func save() async throws {
        let objects = transactions.map { $0.jsonObject }

        guard JSONSerialization.isValidJSONObject(objects) else {
            Logger.shared.log(
                .error,
                message: "Некорректный формат JSON для сохранения",
                metadata: ["❌": "TransactionsFileCache"]
            )
            throw TransactionsFileCacheError.invalidFormat
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
            try await writeData(data, to: fileURL)
        } catch {
            Logger.shared.log(
                .error,
                message: "Ошибка при сохранении файла: \(error.localizedDescription)",
                metadata: ["❌": "TransactionsFileCache"]
            )
            throw error
        }
    }

    public func load() async throws {
        do {
            let data = try await readData(from: fileURL)
            guard let array = try JSONSerialization.jsonObject(with: data) as? [Any] else {
                Logger.shared.log(
                    .error,
                    message: "Неверный формат файла транзакций",
                    metadata: ["❌": "TransactionsFileCache"]
                )
                throw TransactionsFileCacheError.invalidFormat
            }

            var parsed: [TransactionModel] = []
            var errorCount = 0

            for (index, obj) in array.enumerated() {
                if let trans = TransactionModel.parse(jsonObject: obj) {
                    parsed.append(trans)
                } else {
                    Logger.shared.log(
                        .error,
                        message: "Ошибка парсинга транзакции №\(index)",
                        metadata: ["❌": "TransactionsFileCache"]
                    )
                    errorCount += 1
                }
            }
            transactions = parsed
            if errorCount > 0 {
                Logger.shared.log(
                    .info,
                    message: "Некоторые транзакции не были загружены (\(errorCount) ошибок)",
                    metadata: ["⚠️": "TransactionsFileCache"]
                )
            }
        } catch {
            Logger.shared.log(
                .error,
                message: "Ошибка при загрузке файла: \(error.localizedDescription)",
                metadata: ["❌": "TransactionsFileCache"]
            )
            throw error
        }
    }

    public func clear() {
        transactions.removeAll()
    }

    // MARK: - Private Methods

    private func writeData(_ data: Data, to url: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try data.write(to: url, options: .atomic)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func readData(from url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Errors

    public enum TransactionsFileCacheError: Error {
        case invalidFormat
    }
}
