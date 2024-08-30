//
//  StopWatchAttribute.swift
//  StopWatch
//
//  Created by Nishanth on 30/08/24.
//

import Foundation
import SwiftUI
import ActivityKit
import Foundation

struct StopWatchAttribute: ActivityAttributes{
    
    public typealias TimeTrackingStatus = ContentState
    
    
    public struct ContentState: Codable, Hashable{
        var startTime: Date
    }
}
