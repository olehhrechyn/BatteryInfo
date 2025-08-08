//
// BatteryInfoApp.swift
// BatteryInfo
//
// Created by Oleh Hrechyn on 08.08.2025.
//

import SwiftUI
import BackgroundTasks

@main
struct BatteryInfoApp: App {

    @Environment(\.scenePhase) private var scenePhase

    init() {
        BackgroundTasksService.shared.registerBackgroundTasks()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: BatteryInfoViewModel())
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                BackgroundTasksService.shared.scheduleAppRefresh()
            }
        }
    }
}
