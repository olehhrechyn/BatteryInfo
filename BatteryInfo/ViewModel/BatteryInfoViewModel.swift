//
//  BatteryInfoViewModel.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//

import Foundation
import Combine

class BatteryInfoViewModel: ObservableObject {
    @Published var statusMessage: String = "Натисніть кнопку, щоб оновити дані."
    
    func refreshPercentage() {
        statusMessage = "Оновлення..."
        BatteryMonitoringService.shared.fetchAndUploadBatteryData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let level):
                    self?.statusMessage = "Рівень заряду: \((level * 100).formatted())%"
                case .failure(let error):
                    self?.statusMessage = "Помилка: \(error.localizedDescription)"
                }
            }
        }
    }
}
