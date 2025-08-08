//
//  NetworkService.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//

import Foundation

class NetworkService {
    // має бути якась структура, але у нас лише один URL
    private let url = URL(string: AppConstants.API.postsEndpoint)
    
    func sendDeviceData(_ deviceData: DeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(deviceData)
            let base64Data = jsonData.base64EncodedData()
            
            let payload = ["data": base64Data.base64EncodedString()]
            request.httpBody = try JSONEncoder().encode(payload)
            
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(())) // Повертаємо Void для простоти
        }
        task.resume()
    }
}
