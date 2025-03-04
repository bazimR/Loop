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
    var habitList: HabitList
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                        TextField("Description", text: $title, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                    }
                    Button {
                        habitList.value
                            .append(
                                .init(
                                    title: "test",
                                    description: "kjksafjnkljkfj",
                                    type: "health"))
                        path.removeLast()
                    } label: {
                        Text("Save")
                            .font(.title3.bold())
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent).listRowInsets(
                        EdgeInsets())
                }
            }
        }.navigationTitle("Add habit").navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    @Previewable @State var pathPrev = NavigationPath()
    AddHabit(habitList: HabitList(), path: $pathPrev)
}
