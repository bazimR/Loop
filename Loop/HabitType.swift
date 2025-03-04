//
//  HabitType.swift
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
