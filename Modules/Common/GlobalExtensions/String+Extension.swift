//
//  String+Extension.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.06.2025.
//

import Foundation

public extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
