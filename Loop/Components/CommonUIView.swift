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
            withAnimation(.bouncy) {
                onTap()
            }
        } label: {
            Image(systemName: value ? "checkmark.square.fill" : "square")
        }
    }
}
