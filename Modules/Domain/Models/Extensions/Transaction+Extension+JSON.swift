//
//  Transaction+Extension+JSON.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation
import Common

public extension Transaction {

    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    static func parse(jsonObject: Any) -> Transaction? {
        guard JSONSerialization.isValidJSONObject(jsonObject),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject),
              let transaction = try? jsonDecoder.decode(Transaction.self, from: data)
        else {
            Logger.shared.log(
                .error,
                message: "Ошибка при парсинге JSON в Transaction",
                metadata: ["❌": "Transaction"]
            )
            return nil
        }
        return transaction
    }

    var jsonObject: Any? {
        guard let data = try? Transaction.jsonEncoder.encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: [])
        else {
            Logger.shared.log(
                .error,
                message: "Ошибка при преобразовании Transaction в JSON",
                metadata: ["❌": "Transaction"]
            )
            return nil
        }
        return json
    }
}
