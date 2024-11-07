//
//  Task.swift
//  TaskManagementSwiftUI
//
//  Created by Hakob Ghlijyan on 06.11.2024.
//

import SwiftUI

struct TaskCalendar: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
