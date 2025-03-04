//
//  ContentView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

enum Routes {
    case add
}
@Observable
class PathStore {
    var path: NavigationPath = NavigationPath()
}

@Observable
class HabitList {
    var value = [HabitItem]()
    var healthCount: Int {
        value.filter { $0.type == "Health" }.count
    }
    var goalCount: Int {
        value.filter { $0.type == "Goal" }.count
    }
    var workCount: Int {
        value.filter { $0.type == "Work" }.count
    }
    var otherCount: Int {
        value.filter { $0.type == "Others" }.count
    }

    func addHabit(_ habit: HabitItem) {
        value.append(habit)
    }

    func toggleCompletion(for habitId: UUID) {
        if let index = value.firstIndex(where: { $0.id == habitId }) {
            value[index].isCompleted.toggle()
        }
    }
    func removeHabit(for habitId: UUID) {
        if let index = value.firstIndex(where: { $0.id == habitId }) {
            value.remove(at: index)
        }
    }
}

struct ContentView: View {
    @State private var toggle: Bool = false
    @State private var pathStore = PathStore()
    @State private var habitList = HabitList()
    var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: Date())
    }
    // Computed property for habit types ✅ Updated dynamically
    var habitTypes: [HabitType] {
        [
            .init(
                name: "Health", count: habitList.healthCount,
                systemImage: "heart.fill", color: .green),
            .init(
                name: "Work", count: habitList.workCount,
                systemImage: "briefcase.circle.fill", color: .blue),
            .init(
                name: "Goal", count: habitList.goalCount, systemImage: "target",
                color: .red),
            .init(
                name: "Others", count: habitList.otherCount,
                systemImage: "folder.fill", color: .yellow),
        ]
    }

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(habitTypes) { type in
                            HabitTypeCardView(type: type)
                        }
                    }
                    LazyVStack {
                        ForEach(habitList.value) { item in
                            NavigationLink {
                                Text("details screen")
                            } label: {
                                HabitListItem(
                                    habitItem: item,
                                    habitTypes: habitTypes,
                                    toggleCompletion: {
                                        habitList
                                            .toggleCompletion(for: $0)
                                    },
                                    remove: {
                                        habitList.removeHabit(for: item.id)
                                    }
                                )
                            }
                        }
                    }.padding(.top)
                }.padding()

            }.navigationDestination(
                for: Routes.self,
                destination: { route in
                    switch route {
                    case .add:
                        AddHabit(
                            habitList: habitList,
                            path: $pathStore.path,
                            habitTypes: habitTypes
                        )
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack(alignment: .bottom) {
                        Text("Loop").font(.largeTitle.bold())
                        Text("\(todayDate)")
                            .font(.title.bold())
                            .foregroundColor(.gray)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add habit", systemImage: "plus") {
                        pathStore.path.append(Routes.add)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
