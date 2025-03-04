//
//  ContentView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitItem: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var type: String
}
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

    func addHabit(_ habit: HabitItem) {
        value.append(habit)
    }

    func toggleCompletion(for habitId: UUID) {
        if let index = value.firstIndex(where: { $0.id == habitId }) {
            value[index].isCompleted.toggle()
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
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(habitTypes) { type in
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: type.systemImage)
                                    .font(.title).foregroundColor(.white)
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
                    LazyVStack {
                        ForEach(habitList.value) { item in
                            NavigationLink {
                                Text("details screen")
                            } label: {
                                HStack(alignment: .top, spacing: 20) {
                                    Checkbox(
                                        onTap: {
                                            habitList
                                                .toggleCompletion(
                                                    for: item.id
                                                )
                                        },
                                        value: item.isCompleted
                                    )
                                    .font(.title2)
                                    .foregroundColor(
                                        item.isCompleted ? .gray : .primary
                                    )
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.headline)
                                            .foregroundColor(
                                                item.isCompleted
                                                    ? .gray : .primary
                                            ).strikethrough(item.isCompleted)
                                        Text("Others")
                                            .font(.subheadline)
                                            .foregroundColor(
                                                item.isCompleted
                                                    ? .gray : .yellow
                                            )
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(
                                                item.isCompleted
                                                    ? .gray.opacity(0.3)
                                                    : .yellow.opacity(0.3)
                                            )
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }.padding(.top)
                }.padding()

            }.navigationDestination(
                for: Routes.self,
                destination: { route in
                    switch route {
                    case .add:
                        AddHabit(habitList: habitList, path: $pathStore.path)
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
