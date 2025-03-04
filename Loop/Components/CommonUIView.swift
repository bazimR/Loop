//
//  CommonUIView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct Checkbox: View {
    @Binding var value: Bool
    var body: some View {
        Button {
            withAnimation(.bouncy) {
                value.toggle()
            }
        } label: {
            Image(systemName: value ? "checkmark.square.fill" : "square")
        }
    }
}

#Preview {
    @Previewable @State var Boolen = false
    Checkbox(value: $Boolen)
}
