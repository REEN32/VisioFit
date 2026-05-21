import CoreData
import SwiftUI

class RequestViewModel {
    func calculatePercent(for workoutSet: WorkoutSet, in workouts: FetchedResults<Workout>) -> Double {
        let completedApproaches = workouts.filter { workout in
            guard let exSet = workout.exerciseSet else { return false }
            return exSet.trainingType == workoutSet.trainingType
        }.reduce(0) { result, workout in
            result + Int(workout.exerciseSet?.approach ?? 0)
        }
        guard workoutSet.approach > 0 else { return 0 }
        
        return (Double(completedApproaches) / Double(workoutSet.approach)) * 100
    }
    
    static func todayPredicate() -> NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfDay = calendar.startOfDay(for: now)
        

        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return NSPredicate(value: false)
        }
        
        return NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
    }
}
