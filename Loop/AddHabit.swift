//
//  AddHabit.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct AddHabit: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var type: String = "Health"
    @State private var showError: Bool = false
    @State private var errorMsg: String = ""
    var habitList: HabitList
    @Binding var path: NavigationPath
    var habitTypes: [HabitType]
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                        TextField(
                            "Description",
                            text: $description,
                            axis: .vertical
                        )
                        .lineLimit(4, reservesSpace: true)
                    }
                    Section {
                        Picker(
                            "Select a habit type :", selection: $type
                        ) {
                            ForEach(habitTypes) { type in
                                HStack {
                                    Image(systemName: type.systemImage)
                                    Text(
                                        type.name
                                    ).font(.headline).foregroundColor(.primary)
                                }.foregroundColor(type.color).tag(type.name)
                            }
                        }.pickerStyle(.inline)

                    }
                    Button {
                        handleSave()

                    } label: {
                        Text("Save")
                            .font(.title3.bold())
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent).listRowInsets(
                        EdgeInsets())
                }
                if showError {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }

            }
        }.navigationTitle("Add habit").navigationBarTitleDisplayMode(.large)
    }
    func handleSave() {
        guard !title.isEmpty else {
            error(error: "Title is empty")
            return
        }
        guard !description.isEmpty else {
            error(error: "description is empty")
            return
        }

        habitList
            .addHabit(
                .init(
                    title: title,
                    description: description,
                    type: type
                )
            )
        path.removeLast()
    }
    func error(error: String) {
        errorMsg = error
        showError = true
    }
}

#Preview {
    @Previewable @State var pathPrev = NavigationPath()
    let habitTypes: [HabitType] = [
        .init(
            name: "Health",
            count: 0,
            systemImage: "heart.fill",
            color: .green
        ),
        .init(
            name: "Work",
            count: 0,
            systemImage: "briefcase.circle.fill",
            color: .blue
        ),
        .init(name: "Goal", count: 0, systemImage: "target", color: .red),
        .init(
            name: "Others",
            count: 0,
            systemImage: "folder.fill",
            color: .yellow
        ),

    ]
    AddHabit(habitList: HabitList(), path: $pathPrev, habitTypes: habitTypes)
}
