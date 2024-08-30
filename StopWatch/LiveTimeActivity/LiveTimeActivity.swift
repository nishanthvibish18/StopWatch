//
//  StopWatchActivity.swift
//  StopWatchActivity
//
//  Created by Nishanth on 30/08/24.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct StopWatchActivity: Widget{
    var body: some WidgetConfiguration{
        ActivityConfiguration(for: StopWatchAttribute.self) { context in
            TimerLoadView(context: context)
        } dynamicIsland: { context in
            
            DynamicIsland {
                DynamicIslandExpandedRegion(.center){
                    Text(context.state.startTime, style: .relative)
                }
            } compactLeading: {
                Text("Stop Watch")
            } compactTrailing: {
                Image(systemName: "clock.fill")

            } minimal: {
                Text(context.state.startTime, style: .relative)
            }

        }

    }
}


struct TimerLoadView: View {
    let context: ActivityViewContext<StopWatchAttribute>
    var body: some View {
        VStack(alignment: .center, content: {
            Text(context.state.startTime, style: .relative)
                .foregroundStyle(Color.cyan)
        })
        
    }
    
    
 
}
