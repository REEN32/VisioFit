import Foundation
import Combine

class StatisticViewModel: ObservableObject {
    @Published var rawWorkouts: Set<Workout> = []
    @Published var timePeriod: TimePeriod = .week
    
    @Published private(set) var averageAccuracyText: String = "–"
    @Published private(set) var repeatCount: String = "–"
    @Published private(set) var accuracyChange: String = "+0"
    @Published private(set) var repeatChange: String = "+0"
    @Published private(set) var chartData: [Double] = []
    @Published private(set) var accuracyDiff: String = "+0"
    
    @Published private(set) var pushupsReps: String = ""
    @Published private(set) var squatReps: String = ""
    @Published private(set) var plankReps: String = ""
    
    @Published private(set) var pushupsSession: String = ""
    @Published private(set) var squatSession: String = ""
    @Published private(set) var plankSession: String = ""
    
    @Published private(set) var pushupsAccuracy: String = ""
    @Published private(set) var squatAccuracy: String = ""
    @Published private(set) var plankAccuracy: String = ""
    
    var timePeriodString: String {
        switch timePeriod {
        case .week:
            return "дням"
        case .month:
            return "неделям"
        case .year:
            return "месяцам"
        case .allTime:
            return "годам"
        }
    }
    
    var timeAverageString: String {
        switch timePeriod {
        case .week:
            return "прошлой недели"
        case .month:
            return "прошлого месяца"
        case .year:
            return "прошлого года"
        case .allTime:
            return "прошлой недели"
        }
    }
    
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
        self.setChartDate(for: workouts, by: period)
        self.setExerciseInfo(for: workouts, by: period)
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
            resultAccuracy = Int((accuracySum / Double(workouts.count)).rounded())
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
    
    private func setChartDate(for workouts: Set<Workout>, by period: TimePeriod) {
        func average(_ arr: [Workout]) -> Double {
            guard arr.count != 0 else { return 0 }
            let sum = arr.reduce(0) { partialResult, workout in
                partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
            }
            return sum / Double(arr.count)
        }
        
        
        let lastWorkoutsNil = filterLast(workouts, by: period)
        let lastWorkouts = filterNil(lastWorkoutsNil)
        let calendar = Calendar.current
        
        let component: Calendar.Component
        switch period {
        case .week:
            component = .day
        case .month:
            component = .weekOfYear
        case .year:
            component = .month
         case .allTime:
            component = .year
        }
        
        let groupedDictionary = Dictionary(grouping: lastWorkouts) { (workout) -> Date in
            let workoutDate = workout.date ?? Date()
                    
            if let startOfInterval = calendar.dateInterval(of: component, for: workoutDate)?.start {
                return startOfInterval
            }
            return calendar.startOfDay(for: workoutDate)
        }
        let sortedKeys = groupedDictionary.keys.sorted(by: <)
        let sortedArrayOfArrays = sortedKeys.compactMap { date in
            return groupedDictionary[date]
        }
        
        var resultArray: [Double] = []
        for arr in sortedArrayOfArrays {
            resultArray.append((average(arr) * 100).rounded() / 100)
        }
        
        var resultData: [Double] = []
        switch period {
        case .week:
            resultData = Array(repeating: 0, count: 7)
        case .month:
            resultData = Array(repeating: 0, count: 4)
        case .year:
            resultData = Array(repeating: 0, count: 12)
        case .allTime:
            resultData = Array(repeating: 0, count: 4)
        }
        
        var index = 0
        for i in (resultData.count - resultArray.count)..<resultData.count {
            resultData[i] = resultArray[index]
            index += 1
        }
        self.chartData = resultData
        
        guard let last = resultData.popLast(), let beforeLast = resultData.popLast() else { self.accuracyDiff = "+0"; return }
        let diff = ((last - beforeLast) * 100).rounded() / 100
        if diff < 0 {
            self.accuracyDiff = "\(diff)"
        } else {
            self.accuracyDiff = "+\(diff)"
        }
    }
    
    private func setExerciseInfo(for workouts: Set<Workout>, by period: TimePeriod) {
        let dividedWorkouts = Dictionary(grouping: workouts) { workout in
            return workout.exerciseSet?.trainingType
        }
        
        let timePlank = self.filterLast(Set(dividedWorkouts[.plank] ?? []), by: period)
        let timePushup = self.filterLast(Set(dividedWorkouts[.pushup] ?? []), by: period)
        let timeSquat = self.filterLast(Set(dividedWorkouts[.squat] ?? []), by: period)
        
        self.plankSession = "\(timePlank.count)"
        self.pushupsSession = "\(timePushup.count)"
        self.squatSession = "\(timeSquat.count)"
        
        self.plankReps = "\(calculateRepsSum(for: timePlank))"
        self.pushupsReps = "\(calculateRepsSum(for: timePushup))"
        self.squatReps = "\(calculateRepsSum(for: timeSquat))"
        
        func setAccuracy(for workout: Set<Workout>, to variable: inout String) {
            if let accuracy = calculateAverageAccuracy(for: workout) {
                variable = "\(accuracy)"
            } else {
                variable = "–"
            }
        }
        setAccuracy(for: filterNil(timePlank), to: &self.plankAccuracy)
        setAccuracy(for: filterNil(timePushup), to: &self.pushupsAccuracy)
        setAccuracy(for: filterNil(timeSquat), to: &self.squatAccuracy)
    }
}
