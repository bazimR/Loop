//
//  HabitTypeCardView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitTypeCardView: View {
    let type: HabitType
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: type.systemImage)
                    .font(.title).foregroundColor(.white)
            }
            HStack(spacing: 5) {
                Text("\(type.count)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.6))
            }
        }.padding().frame(
            maxWidth: .infinity, alignment: .leading
        ).background(
            type.color.opacity(0.7)
        ).clipShape(.rect(cornerRadius: 20))
    }
}
