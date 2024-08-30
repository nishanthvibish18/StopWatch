//
//  StopWatchApp.swift
//  StopWatch
//
//  Created by Nishanth on 30/08/24.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct StopWatchApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var stopWatchVm = StopwatchViewModel()
    let taskId = "com.backgroundtask.stopwatch"
    init(){
        NotificationManager.sharedInstance.requestNotificationPermission()
        registerBackgroundTask()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: stopWatchVm)
                .onChange(of: scenePhase) { oldValue, newValue in
                    if(newValue == .background){
                        NotificationManager.sharedInstance.setupBackgroundNotifications(timer: "Timer: \(stopWatchVm.formattedTime())", title: "App in Background", timeInterval: 1)
//                        scheduleBackgroundTask()
                    }
            
                }
        }
    }
    
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundTask() {
        BGTaskScheduler.shared.getPendingTaskRequests { request in
            guard request.isEmpty else { return }
            let request = BGProcessingTaskRequest(identifier: taskId)
            request.requiresNetworkConnectivity = false
            request.requiresExternalPower = false
            request.earliestBeginDate = Date(timeIntervalSinceNow: 600)
            NotificationManager.sharedInstance.setupBackgroundNotifications(timer: "", title: "App will be removed after 5 minutes later", timeInterval: 1)
            do {
               
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Unable to schedule background task: \(error.localizedDescription)")
            }
        }
        
    }
    
    func handleBackgroundTask(task: BGAppRefreshTask) {
        task.setTaskCompleted(success: true)
    }
}


class NotificationManager{
    
    static let sharedInstance = NotificationManager()
    private init(){}
    
    func removeNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["stopwatchNotification"])
        
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
    }
    
    func setupBackgroundNotifications(timer: String,title: String ,timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = timer
        content.categoryIdentifier = "stopwatch"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "stopwatchNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
}


extension Notification.Name{
    static let resetNotification = Notification.Name("resetnotification")
}
