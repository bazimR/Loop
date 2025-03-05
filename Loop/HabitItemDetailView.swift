//
//  HabitItemDetailView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitItemDetailView: View {
    let habitItem: HabitItem
    let habitType: HabitType
    init(habitItem: HabitItem, habitTypes: [HabitType]) {
        self.habitItem = habitItem
        if let matchedType = habitTypes.first(where: {
            $0.name.lowercased() == habitItem.type.lowercased()
        }) {
            self.habitType = matchedType
        } else {
            fatalError("Missing HabitType for \(habitItem.type)")
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    habitType.color,
                    habitType.color.opacity(0.5),
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ).ignoresSafeArea()
            VStack(alignment: .leading) {
                Text(habitItem.title).font(.largeTitle.bold())
                Text(habitItem.description)
                Spacer()
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }.toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: habitType.systemImage)
                    Text(habitType.name).font(.title2)

                }
            }
        }
    }
}

#Preview {

    HabitItemDetailView(
        habitItem: HabitItem(
            title: "test", description: "dssdfdfssdfdf", type: "Health"),
        habitTypes: [
            HabitType(
                name: "Health",
                count: 3,
                systemImage: "heart",
                color: .green
            )
        ]
    )
}
