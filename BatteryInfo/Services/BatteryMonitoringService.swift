//
//  BatteryMonitoringService.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//

import UIKit

class BatteryMonitoringService {
    
    // має бути DI контейнер, але в рамках ТЗ використовуємо singleton
    static let shared = BatteryMonitoringService()
    
    private let networkService = NetworkService()
    

    func fetchAndUploadBatteryData(completion: @escaping (Result<Float, Error>) -> Void) {
        
        // 1. Увімкнути моніторинг
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // 2. Перевірити, чи доступний заряд
        guard UIDevice.current.batteryState != .unknown else {
            UIDevice.current.isBatteryMonitoringEnabled = false
            completion(.failure(DataError.batteryInfoUnavailable))
            return
        }
        let batteryLevel = UIDevice.current.batteryLevel
        
        // 3. Вимкнути моніторинг одразу після зчитування
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        // 4. Створити модель даних
        let deviceData = DeviceData(
            batteryLevel: batteryLevel,
            timestamp: ISO8601DateFormatter().string(from: Date())
        )
        
        // 5. Відправити дані
        networkService.sendDeviceData(deviceData) { result in
            switch result {
            case .success:
                completion(.success(batteryLevel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    enum DataError: Error, LocalizedError {
        case batteryInfoUnavailable
    }
}
