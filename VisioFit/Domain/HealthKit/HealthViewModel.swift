import SwiftUI
import HealthKit
import Combine

class HealthViewModel: ObservableObject {
    private let hkManager = HealthKitManager()
    
    @Published var stepsHistory: [Double] = []
    @Published var distanceHistory: [Double] = []
    @Published var caloriesHistory: [Double] = []
    @Published var isAuthorized = false
    
    var calories: Double {
        caloriesHistory.last ?? 0
    }
    var distance: Double {
        distanceHistory.last ?? 0
    }
    var steps: Double {
        stepsHistory.last ?? 0
    }
    
    func authorizeAndLoad() {
        hkManager.requestAuthorization { [weak self] success, error in
            guard let self = self else { return }
            if success {
                self.isAuthorized = true
                self.loadLast7DaysData()
            } else {
                print("Ошибка авторизации HealthKit: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func loadLast7DaysData() {
        hkManager.fetchLast7DaysDailySum(for: .stepCount, unit: HKUnit.count()) { [weak self] rawData in
            guard let self = self else { return }
            self.stepsHistory = self.convertAndSort(rawData: rawData, multiplier: 1.0, fraction: 0)
        }
        
        hkManager.fetchLast7DaysDailySum(for: .distanceWalkingRunning, unit: HKUnit.meter()) { [weak self] rawData in
            guard let self = self else { return }
            self.distanceHistory = self.convertAndSort(rawData: rawData, multiplier: 1.0 / 1000.0, fraction: 2)
        }
        
        hkManager.fetchLast7DaysDailySum(for: .activeEnergyBurned, unit: HKUnit.kilocalorie()) { [weak self] rawData in
            guard let self = self else { return }
            self.caloriesHistory = self.convertAndSort(rawData: rawData, multiplier: 1.0, fraction: 0)
        }
    }
    
    private func convertAndSort(rawData: [Date: Double], multiplier: Double, fraction: Double) -> [Double] {
        let sortedKeys = rawData.keys.sorted(by: <)
        
        return sortedKeys.map { date in
            let value = (rawData[date] ?? 0.0) * multiplier
            return (value * pow(10, fraction)).rounded() / pow(10, fraction)
        }
    }
}
