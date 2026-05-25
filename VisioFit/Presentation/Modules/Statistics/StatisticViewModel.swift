import Foundation
import Combine

class StatisticViewModel: ObservableObject {
    @Published var rawWorkouts: Set<Workout> = []
    @Published var timePeriod: TimePeriod = .week
    
    @Published private(set) var averageAccuracyText: String = "–"
    @Published private(set) var repeatCount: String = "–"
    @Published private(set) var accuracyChange: String = "+0"
    @Published private(set) var repeatChange: String = "+0"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($rawWorkouts, $timePeriod)
            .sink { [weak self] workouts, period in
                self?.recalculateStatistic(for: workouts, in: period)
            }
            .store(in: &cancellables)
    }
    
    private func recalculateStatistic(for workouts: Set<Workout>, in period: TimePeriod) {
        let filtredWorkout = filterLast(workouts , by: period)
        
        
        let reps = calculateRepsSum(for: filtredWorkout)
        self.repeatCount = String(reps)
        
        let filtredWorkoutWithoutNil = filterNil(filtredWorkout)
        if let resultAccuracy = calculateAverageAccuracy(for: filtredWorkoutWithoutNil) {
            self.averageAccuracyText = String(resultAccuracy)
        } else {
            self.averageAccuracyText = "–"
        }

        let nilFiltredWorkout = filterNil(workouts)
        self.calculateAccuracyChange(for: nilFiltredWorkout, by: period)
        self.calculateRepeatChange(for: workouts, by: period)
    }
    
    private func filterLast(_ rawWorkouts: Set<Workout>, by period: TimePeriod) -> Set<Workout> {
        guard period != .allTime else { return rawWorkouts }
        
        guard let startDate = calculateStartDate(for: period) else { return rawWorkouts }
        return rawWorkouts.filter { workout in
            guard let workoutDate = workout.date else { return false }
            return workoutDate >= startDate
        }
    }
    
    private func filterBeforeLast(_ rawWorkouts: Set<Workout>, by period: TimePeriod) -> Set<Workout> {
        let dateTuple = calculatePreviousDate(for: period)
        guard let startDate = dateTuple.0, let endDate = dateTuple.1 else { return rawWorkouts }
        return rawWorkouts.filter { workout in
            guard let workoutDate = workout.date else { return false }
            return endDate >= workoutDate && workoutDate >= startDate
        }
    }
    
    private func filterNil(_ rawWorkouts: Set<Workout>) -> Set<Workout>{
        let filtredWorkoutWithoutNil = rawWorkouts.filter { $0.exerciseSet?.metricPoint?.quality != -1.0 }
        return filtredWorkoutWithoutNil
    }
    
    private func calculateStartDate(for period: TimePeriod) -> Date? {
        let now = Date()
        let calendar = Calendar.current
    
        switch period {
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: now)
            
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: now)
            
        case .year:
            return calendar.date(byAdding: .year, value: -1, to: now)
            
        case .allTime:
            return nil
        }
    }
    
    private func calculatePreviousDate(for period: TimePeriod) -> (Date?, Date?) {
        let now = Date()
        let calendar = Calendar.current
    
        switch period {
        case .week:
            let start = calendar.date(byAdding: .day, value: -14, to: now)
            let end = calendar.date(byAdding: .day, value: -7, to: now)
            return (start, end)
            
        case .month:
            let start = calendar.date(byAdding: .month, value: -2, to: now)
            let end = calendar.date(byAdding: .month, value: -1, to: now)
            return (start, end)
            
        case .year:
            let start = calendar.date(byAdding: .year, value: -2, to: now)
            let end = calendar.date(byAdding: .year, value: -1, to: now)
            return (start, end)
            
        case .allTime:
            let start = calendar.date(byAdding: .day, value: -14, to: now)
            let end = calendar.date(byAdding: .day, value: -7, to: now)
            return (start, end)
        }
    }
    
    private func calculateAverageAccuracy(for workouts: Set<Workout>) -> Int? {
        var resultAccuracy: Int? = nil
        let accuracySum = workouts.reduce(0) { partialResult, workout in
            partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
        }
        if workouts.count != 0 {
            resultAccuracy = Int(accuracySum / Double(workouts.count))
        }
        return resultAccuracy
    }
    
    private func calculateRepsSum(for workouts: Set<Workout>) -> Int16 {
        let reps = workouts.reduce(0) { partialResult, workout in
            partialResult + (workout.exerciseSet?.count ?? 0)
        }
        return reps
    }
    
    private func calculateAccuracyChange(for workouts: Set<Workout>, by period: TimePeriod) {
        let lastWorkouts = filterLast(workouts, by: period)
        let beforeLastWorkouts = filterBeforeLast(workouts, by: period)
        
        guard let lastAccuracy = calculateAverageAccuracy(for: lastWorkouts) else { self.accuracyChange = "+0"; return }
        guard let beforeLastAccuracy = calculateAverageAccuracy(for: beforeLastWorkouts) else { self.accuracyChange = "+\(lastAccuracy)"; return }
        let diff = lastAccuracy - beforeLastAccuracy
        if diff < 0 {
            self.accuracyChange = "\(diff)"
        } else {
            self.accuracyChange = "+\(diff)"
        }
    }
    
    private func calculateRepeatChange(for workouts: Set<Workout>, by period: TimePeriod) {
        let lastWorkouts = filterLast(workouts, by: period)
        let beforeLastWorkouts = filterBeforeLast(workouts, by: period)
        
        let lastSum = calculateRepsSum(for: lastWorkouts)
        let beforeLastSum = calculateRepsSum(for: beforeLastWorkouts)
        let diff = lastSum - beforeLastSum
        if diff < 0 {
            self.repeatChange = "\(diff)"
        } else {
            self.repeatChange = "+\(diff)"
        }
    }
}
