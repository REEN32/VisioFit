import Combine
import CoreData

class AccountViewModel: ObservableObject {
    @Published var averageAccuracy: Int?
    
    func calculateAverageAccuracy(from workouts: NSSet) {
        let workoutsSet = (workouts as? Set<Workout> ?? [])
        let filtredWorkoutsSet = workoutsSet.filter { $0.exerciseSet?.metricPoint?.quality != -1 }
        guard filtredWorkoutsSet.count != 0 else { return }
        let accuracySum = filtredWorkoutsSet.reduce(0) { partialResult, workout in
            partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
        }
        self.averageAccuracy = Int(accuracySum / Double(filtredWorkoutsSet.count))
    }
}
