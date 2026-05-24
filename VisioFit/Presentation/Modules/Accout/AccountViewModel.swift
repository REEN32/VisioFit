import Combine
import CoreData

class AccountViewModel: ObservableObject {
    @Published var averageAccuracy: Int?
    
    func calculateAverageAccuracy(from workouts: NSSet) {
        print("in function")
        let accuracySum = (workouts as? Set<Workout> ?? []).reduce(0) { partialResult, workout in
            partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
        }
        print("after calculation")
        print("Debug accuracySum: \(accuracySum)")
        print("Debug count: \(workouts.count)")
        self.averageAccuracy = Int(accuracySum / Double(workouts.count))
    }
}
