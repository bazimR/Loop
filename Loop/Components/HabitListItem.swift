//
//  HabitListItem.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitListItem: View {

    let habitItem: HabitItem
    let habitType: HabitType

    init(
        habitItem: HabitItem, habitTypes: [HabitType],
        toggleCompletion: @escaping (UUID) -> Void
    ) {
        self.habitItem = habitItem
        self.toggleCompletion = toggleCompletion
        // Find the HabitType that matches the habitItem.type
        if let matchedType = habitTypes.first(where: {
            $0.name.lowercased() == habitItem.type.lowercased()
        }) {
            self.habitType = matchedType
        } else {
            fatalError("Missing HabitType for \(habitItem.type)")
        }
    }
    var toggleCompletion: (UUID) -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Checkbox(
                onTap: {
                    toggleCompletion(habitItem.id)
                },
                value: habitItem.isCompleted
            )
            .font(.title2)
            .foregroundColor(
                habitItem.isCompleted ? .gray : .primary
            )
            VStack(alignment: .leading) {
                Text(habitItem.title)
                    .font(.headline)
                    .foregroundColor(
                        habitItem.isCompleted
                            ? .gray : .primary
                    ).strikethrough(habitItem.isCompleted)
                Text(habitType.name)
                    .font(.subheadline)
                    .foregroundColor(
                        habitItem.isCompleted
                            ? .gray : habitType.color
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        habitItem.isCompleted
                            ? .gray.opacity(0.3)
                            : habitType.color.opacity(0.3)
                    )
                    .clipShape(.rect(cornerRadius: 10))
            }
            Spacer()
        }
    }
}
