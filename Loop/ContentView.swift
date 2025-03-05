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
    var path: NavigationPath {
        didSet {
            _save()
        }
    }
    private let savedPath = URL.documentsDirectory.appending(path: "NavPath")
    init() {
        if let data = try? Data(contentsOf: savedPath) {
            if let decodedData = try? JSONDecoder().decode(
                NavigationPath.CodableRepresentation.self,
                from: data
            ) {
                self.path = NavigationPath(decodedData)
                return
            }
        }
        self.path = NavigationPath()
    }

    private func _save() {
        guard let codableRepresentation = path.codable else { return }
        do {
            let data = try JSONEncoder().encode(codableRepresentation)
            try data.write(to: savedPath)
        } catch {
            print("Failed saving nav data.")
        }
    }
}

@Observable
class HabitList {
    var value: [HabitItem] {
        didSet {
            _save()
        }
    }
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
        value.insert(habit, at: 0)
    }
    private let savedPath = URL.documentsDirectory.appending(path: "ValuePath")
    init() {
        if let data = try? Data(contentsOf: savedPath) {
            if let decodedData = try? JSONDecoder().decode(
                [HabitItem].self,
                from: data
            ) {
                self.value = decodedData
                return
            }
        }
        self.value = []
    }

    private func _save() {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: savedPath)
        } catch {
            print("Failed saving value.")
        }
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

    func checkAndResetHabits() {
        // Get the last reset date from UserDefaults, or use a very old date if not found
        let lastResetDate =
            UserDefaults.standard.object(forKey: "lastResetDate") as? Date
            ?? Date.distantPast

        let today = Calendar.current.startOfDay(for: Date())

        if lastResetDate < today {
            value = value.map { habit in
                var updatedHabit = habit
                updatedHabit.isCompleted = false
                return updatedHabit
            }

            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
            print("✅ Habits reset successfully")
        } else {
            print("⏳ Reset already done today, skipping")
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
                            NavigationLink(value: item) {
                                VStack {
                                    HabitListItem(
                                        habitItem: item,
                                        habitTypes: habitTypes,
                                        toggleCompletion: {
                                            habitList
                                                .toggleCompletion(for: $0)
                                        },
                                        remove: {
                                            habitList.removeHabit(
                                                for: item.id)
                                        }
                                    )

                                    Separator()

                                }.padding(.vertical, 4)
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
            ).navigationDestination(
                for: HabitItem.self,
                destination: { item in
                    HabitItemDetailView(habitItem: item, habitTypes: habitTypes)
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
        }.onAppear {
            habitList.checkAndResetHabits()
        }
    }
}

#Preview {
    ContentView()
}
