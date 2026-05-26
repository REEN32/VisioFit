import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    private let typesToRead: Set<HKQuantityType> = [
        HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard isAvailable else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit недоступен на этом устройстве"]))
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func fetchTodaySum(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .separateBySource) { _, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                DispatchQueue.main.async { completion(0.0) }
                return
            }
            
            let value = sum.doubleValue(for: unit)
            DispatchQueue.main.async {
                completion(value)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchLast7DaysDailySum(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping ([Date: Double]) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        let todayStart = calendar.startOfDay(for: now)
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: todayStart) else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .separateBySource,
            anchorDate: todayStart,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { _, results, error in
            var dailyData: [Date: Double] = [:]
            
            guard let statsCollection = results else {
                DispatchQueue.main.async { completion([:]) }
                return
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                let date = calendar.startOfDay(for: statistics.startDate)
                let sum = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0.0
                dailyData[date] = sum
            }
            
            DispatchQueue.main.async {
                completion(dailyData)
            }
        }
        
        healthStore.execute(query)
    }
}
