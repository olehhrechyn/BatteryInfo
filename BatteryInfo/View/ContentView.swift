//
//  ContentView.swift
//  BatteryInfo
//
//  Created by Oleh Hrechyn on 08.08.2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: BatteryInfoViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "battery.100")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("BatteryInfo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(viewModel.statusMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Оновити зараз") {
                viewModel.refreshPercentage()
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
            .padding()
        }
        .padding()
        .onAppear {
            viewModel.refreshPercentage()
        }
    }
}

#Preview {
    ContentView(viewModel: BatteryInfoViewModel()) // має бути DI контейнер для cтворення VM, але це не в рамках ТЗ
}
