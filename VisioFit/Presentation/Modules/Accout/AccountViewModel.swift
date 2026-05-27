import Combine
import CoreData

class AccountViewModel: ObservableObject {
    @Published var averageAccuracy: Int?
    @Published var user: User
    
    private var rawWorkouts: Set<Workout> {
        user.workout as? Set<Workout> ?? []
    }
    
    var isStreakActiveToday: Bool {
        let calendar = Calendar.current
        return rawWorkouts.contains { workout in
            guard let date = workout.date else { return false }
            return calendar.isDateInToday(date)
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    func currentStreak() {
        let calendar = Calendar.current
        
        let workoutDays = Set(rawWorkouts.compactMap { workout -> Date? in
            guard let date = workout.date else { return nil }
            return calendar.startOfDay(for: date)
        })
        
        let sortedDays = workoutDays.sorted(by: >)
        
        guard let mostRecentDay = sortedDays.first else { user.streak = 0; return }
        
        let isToday = calendar.isDateInToday(mostRecentDay)
        let isYesterday = calendar.isDateInYesterday(mostRecentDay)
        
        guard isToday || isYesterday else { user.streak = 0; return }
        
        var streak = 1
        var currentCheckDay = mostRecentDay
        
        for i in 1..<sortedDays.count {
            let previousDay = sortedDays[i]
            
            if let expectedDay = calendar.date(byAdding: .day, value: -1, to: currentCheckDay),
               previousDay == expectedDay {
                streak += 1
                currentCheckDay = previousDay
            } else {
                break
            }
        }
        
        checkAndSave(Int16(streak))
    }
    
    private func checkAndSave(_ streak: Int16) {
        self.user.streak = streak
        if self.user.maxStreak < streak {
            self.user.maxStreak = streak
        }
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.save()
        }
    }
    
    func calculateAverageAccuracy() {
        let filtredWorkoutsSet = self.rawWorkouts.filter { $0.exerciseSet?.metricPoint?.quality != -1 }
        guard filtredWorkoutsSet.count != 0 else { return }
        let accuracySum = filtredWorkoutsSet.reduce(0) { partialResult, workout in
            partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
        }
        self.averageAccuracy = Int((accuracySum / Double(filtredWorkoutsSet.count)).rounded())
    }
}
