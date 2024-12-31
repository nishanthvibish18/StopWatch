//
//  ViewModel.swift
//  StopWatch
//
//  Created by Nishanth on 30/08/24.
//

import Foundation
import ActivityKit


enum Precision: String, CaseIterable {
    case seconds = "Seconds"
    case milliseconds = "Milliseconds"
}

class StopwatchViewModel: ObservableObject {
    @Published var timeElapsed: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var selectedPrecision: Precision = .seconds
    private var timer: Timer?
    private var startDate: Date?
  private var activity: Activity<StopWatchAttribute>? = nil
    
    func start() {
        isRunning = true
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: selectedPrecision == .seconds ? 1 : 0.001, repeats: true) { _ in
            self.updateTime()
        }
        self.startActivity()
        
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        self.stopActivity()
        timer = nil
    }
    
    func reset() {
        timeElapsed = 0
        timer?.invalidate()
        timer = nil
        isRunning = false
        self.stopActivity()
    }
    
    func updateTime() {
        guard let startDate = startDate else { return }
        timeElapsed = Date().timeIntervalSince(startDate)
       
    }
    
    private func startActivity(){
        guard let startDate = startDate else { return }
        let stopWatchAttributes = StopWatchAttribute()
        let state = StopWatchAttribute.ContentState(startTime: startDate)
        
      activity = try? Activity<StopWatchAttribute>.request(attributes: stopWatchAttributes, contentState: state, pushType: nil)
    }
    
    private func stopActivity(){
        guard let startDate = startDate else{return}
        let state = StopWatchAttribute.ContentState(startTime: startDate)
        
        Task{
            await activity?.end(using:state, dismissalPolicy: .immediate)
        }
        
        self.startDate = nil
    }
    
    func formattedTime() -> String {
        let hours = Int(timeElapsed) / 3600
            let minutes = (Int(timeElapsed) % 3600) / 60
            let seconds = Int(timeElapsed) % 60
            
            if selectedPrecision == .milliseconds {
                let milliseconds = Int((timeElapsed * 1000).truncatingRemainder(dividingBy: 1000)) / 10
                return String(format: "%02d:%02d:%02d:%03d", hours, minutes, seconds, milliseconds)
            } else {
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
    }
}
