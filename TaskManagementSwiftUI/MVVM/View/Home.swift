//
//  Home.swift
//  TaskManagementSwiftUI
//
//  Created by Hakob Ghlijyan on 06.11.2024.
//

import SwiftUI

struct Home: View {
    @StateObject private var viewModel: TaskViewModel = TaskViewModel()
    @Namespace private var namespaceAnimation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(
                spacing: 20,
                pinnedViews: [.sectionHeaders]) {
                    Section {
                        //MARK: - Current week
                        ScrollView(.horizontal, showsIndicators: false) {
                            //MARK: - DATE
                            HStack(spacing: 10.0) {
                                ForEach(viewModel.currentWeek, id: \.self) { day in
                                    VStack(spacing: 10.0) {
                                        Text(viewModel.extractDate(date: day, format: "dd"))
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        // EEE Return day In MON format
                                        Text(viewModel.extractDate(date: day, format: "EEE"))
                                            .font(.system(size: 14))
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 8, height: 8)
                                            .opacity(viewModel.isToday(date: day) ? 1 : 0)
                                    }
                                    .foregroundStyle(viewModel.isToday(date: day) ? .primary : .secondary)
                                    .foregroundColor(viewModel.isToday(date: day) ? .white : .black)
                                    .frame(width: 45, height: 90)
                                    .background(
                                        ZStack {
                                            //MARK: - match geometry effect
                                            if viewModel.isToday(date: day) {
                                                Capsule()
                                                    .fill(.black)
                                                    .matchedGeometryEffect(id: "current_day", in: namespaceAnimation)
                                            }
                                        }
                                    )
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.currentDay = day
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            //MARK: - TASKS
                            TaskView()
                        }
                    } header: {
                        HeaderView()
                    }
                }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    //MARK: - Header View
    @ViewBuilder func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                Text("Today").font(.largeTitle).bold()
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }

        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(.white)
    }
        
    //MARK: - Task view
    @ViewBuilder func TaskView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = viewModel.filteredTask {
                if tasks.isEmpty {
                    Text("No Task found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardview(task: task)
                    }
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: viewModel.currentDay) { oldValue, newValue in
            viewModel.filterTodayTasks()
        }
    }
    
    //MARK: - Task Card View
    @ViewBuilder  func TaskCardview(task: TaskCalendar) -> some View {
        HStack(alignment: .top, spacing: 30.0) {
            //1
            VStack(spacing: 10.0) {
                Circle()
                    .fill(viewModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!viewModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1 )
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: 3)
            }
            //2
            VStack {
                //1
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.taskTitle)
                            .font(.headline.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                //2
                if viewModel.isCurrentHour(date: task.taskDate) {
                    //MARK: - Team Members
                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(viewModel.userImage, id: \.self) { user in
                                Image(user)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .background(
                                        Circle().stroke(.black, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                        
                        //MARK: - Check Button
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: Circle())
                        }
                        
                    }
                    .padding(.top, 4)
                }
                
            }
            .foregroundStyle(viewModel.isCurrentHour(date: task.taskDate) ? .white : .primary)
            .padding(viewModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, viewModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(
                Color("AppBlack")
                    .clipShape(.rect(cornerRadius: 20))
                    .opacity(viewModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
            )
        }
        .hLeading()
    }
    
}

#Preview {
    Home()
}


//MARK: - UI design Helper function
extension View {
    // ALIGNMENT
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    //SAFE AREA
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}
