//
//  Category.swift
//  AccountsUI
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation
import Common

public enum Direction: String, Codable {
    case income
    case outcome
}

public struct ExpensesCategory: Identifiable, Codable {
    public let id: Int
    public let name: String
    public let emoji: Character
    public let isIncome: Bool

    public var direction: Direction { isIncome ? .income : .outcome }

    public init(
        id: Int,
        name: String,
        emoji: Character,
        isIncome: Bool
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, emoji, isIncome
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let emojiStr = try container.decode(String.self, forKey: .emoji)
        guard let char = emojiStr.first, emojiStr.count == 1 else {
            throw DecodingError.dataCorruptedError(
                forKey: .emoji,
                in: container,
                debugDescription: "Эмодзи должен состоять из одного символа"
            )
        }
        emoji = char
        isIncome = try container.decode(Bool.self, forKey: .isIncome)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(String(emoji), forKey: .emoji)
        try container.encode(isIncome, forKey: .isIncome)
    }
}
