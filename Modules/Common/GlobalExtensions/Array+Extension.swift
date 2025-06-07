//
//  Array+Extension.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
