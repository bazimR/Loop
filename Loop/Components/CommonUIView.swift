//
//  CommonUIView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct Checkbox: View {
    var onTap: () -> Void
    var value: Bool
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: value ? "checkmark.square.fill" : "square")
                .animation(.bouncy, value: value)
        }
    }
}

struct Separator: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.black.opacity(0.2)).padding(.vertical,4)
    }
}
