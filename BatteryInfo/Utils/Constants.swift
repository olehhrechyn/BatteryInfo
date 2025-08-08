//
//  Constants.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//

import Foundation

enum AppConstants {
    enum BGTask {
        // Ідентифікатор, який ми вказали в Info.plist
        static let refreshIdentifier = "com.hrechyn.BatteryInfo.refresh"
    }
    
    enum API {
        static let postsEndpoint = "https://jsonplaceholder.typicode.com/posts"
    }
}
