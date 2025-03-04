//
//  ContentView.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitType: Identifiable {
    let id: UUID = UUID()
    var name: String
    var count: Int
    var systemImage: String
    var color: Color
}

struct ContentView: View {
    @State private var toggle: Bool = false
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
        NavigationStack {
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
                        ForEach(1..<10) { i in
                            NavigationLink {
                                Text("details screen")
                            } label: {
                                HStack(alignment: .top, spacing: 20) {
                                    Checkbox(value: $toggle)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                    VStack(alignment: .leading) {
                                        Text("habit title")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("Others")
                                            .font(.subheadline)
                                            .foregroundColor(.yellow)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(.yellow.opacity(0.3))
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }.padding(.top)
                }.padding()

            }
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

                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
