//
//  TaskViewModel.swift
//  TaskManagementSwiftUI
//
//  Created by Hakob Ghlijyan on 06.11.2024.
//

import SwiftUI

final class TaskViewModel: ObservableObject {
    // Simple Task
    @Published var storedTask: [TaskCalendar] = [
        // now
        TaskCalendar(
            taskTitle: "Meeting",
            taskDescription: "Discuss team task for the day",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Iconset",
            taskDescription: "Edit icons for team task for next week",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Prototype",
            taskDescription: "Make and send prototype",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Check asset",
            taskDescription: "Start checking the assets",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Team party",
            taskDescription: "Make fun with team mates",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Client Meeting",
            taskDescription: "Explain project to clinet",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "Next Project",
            taskDescription: "Discuss next project with team",
            taskDate: Date.now
        ),
        TaskCalendar(
            taskTitle: "App Proposal",
            taskDescription: "Meet client for next App Proposal",
            taskDate: Date.now
        ),
    ]
    
    @Published var userImage = ["User1","User2","User3","User4","User5"]
    
    //MARK: - Init
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    //MARK: - Current Week Day
    @Published var currentWeek: [Date] = []
    //MARK: - Current Day
    @Published var currentDay: Date = Date()
    //MARK: - Filtered Today Task
    @Published var filteredTask: [TaskCalendar]?
    
    func fetchCurrentWeek() {
        let today = Date()                      //today is current day
        let calendar = Calendar.current         //calendar is current week
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today )   // is current week is current day
        
        guard let firstWeekDay = week?.start else { return }    //first day , is start day
        
        (1...7).forEach { day in      // for each in array for append day is calendar
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    //MARK: - Extract date info
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: - Cheking current day
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay , inSameDayAs: date)
    }
    
    //MARK: - Filter Today Task
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedTask.filter { date in
                return calendar.isDate(date.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1 , task2 in
                    return task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {                                                  
                withAnimation{
                    self.filteredTask = filtered
                }
            }
        }
    }
    
    //MARK: - Checking if the current task hour
    func isCurrentHour(date: Date) -> Bool {
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        let currentHour = calender.component(.hour, from: Date())
        return hour == currentHour
    }
    
}
