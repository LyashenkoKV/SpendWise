//
//  CustomNavigationBar.swift
//  Common
//
//  Created by Konstantin Lyashenko on 14.06.2025.
//

import SwiftUI

public struct CustomNavigationBar: View {

    let leading: AnyView?
    let trailing: AnyView?
    let backgroundColor: Color

    public init(
        leading: AnyView? = nil,
        trailing: AnyView? = nil,
        backgroundColor: Color = .bgSecondary
    ) {
        self.leading = leading
        self.trailing = trailing
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(edges: .top)
            HStack {
                if let leading {
                    leading
                } else {
                    Spacer().frame(width: 44)
                }
                Spacer()
                if let trailing {
                    trailing
                } else {
                    Spacer().frame(width: 44)
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 44)
        }
        .overlay(
            Divider(),
            alignment: .bottom
        )
    }
}

#Preview {
    CustomNavigationBar(
        trailing: AnyView(
            Button(action: { /* Нажатие */ }) {
                Image(systemName: "clock")
                    .font(.system(size: 22))
                    .foregroundColor(Color.systemText)
                    .frame(width: 22, height: 22)
                    .clipShape(Circle())
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
        )
    )
}
