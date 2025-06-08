//
//  Date+Extension.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation

public extension Date {
    var iso8601String: String {
        ISO8601DateFormatter.cached.string(from: self)
    }
    static func fromISO8601(_ string: String) -> Date? {
        ISO8601DateFormatter.cached.date(from: string)
    }
}

private extension ISO8601DateFormatter {
    static let cached: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
