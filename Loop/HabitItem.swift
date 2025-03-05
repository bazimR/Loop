//
//  HabitItem.swift
//  Loop
//
//  Created by Rishal Bazim on 04/03/25.
//

import SwiftUI

struct HabitItem: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var type: String
}
