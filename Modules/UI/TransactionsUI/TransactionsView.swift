//
//  TransactionsUI.swift
//  TransactionsUI
//
//  Created by Konstantin Lyashenko on 06.06.2025.
//

import SwiftUI

public struct TransactionView: View {
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .font(.largeTitle)
    }

    public init() {}
}

#Preview {
    TransactionView()
}
