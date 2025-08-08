//
//  BackgroundTasksService.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//

import BackgroundTasks
import UIKit

final class BackgroundTasksService {

    // має бути DI контейнер, але в рамках ТЗ використовуємо singleton
    static let shared = BackgroundTasksService()

    private init() {}

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: AppConstants.BGTask.refreshIdentifier)
        let time: TimeInterval = 120
        request.earliestBeginDate = Date(timeIntervalSinceNow: time)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Завдання заплановано.")
        } catch {
            print("🛑 Не вдалося запланувати завдання: \(error.localizedDescription)")
        }
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppConstants.BGTask.refreshIdentifier, using: nil) { task in
            guard let task = task as? BGAppRefreshTask else { return }
            self.handleAppRefresh(task: task)
        }
    }
}

private extension BackgroundTasksService {
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        let operation = BlockOperation {
            BatteryMonitoringService.shared.fetchAndUploadBatteryData { result in
                switch result {
                case .success(let level):
                    print("✅ Фонове завдання виконано успішно. Рівень заряду: \(level)")
                    task.setTaskCompleted(success: true)
                case .failure(let error):
                    print("🛑 Помилка у фоновому завданні: \(error.localizedDescription)")
                    task.setTaskCompleted(success: false)
                }
            }
        }

        task.expirationHandler = {
            operation.cancel()
        }

        OperationQueue().addOperation(operation)
    }
}
