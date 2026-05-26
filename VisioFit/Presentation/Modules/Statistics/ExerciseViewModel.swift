import Foundation
import Combine

enum ChartState {
    case rep
    case session
    case accuracy
}

class ExerciseViewModel: ObservableObject {
    @Published var rawWorkouts: Set<Workout> = []
    @Published var timePeriod: TimePeriod = .week
    @Published var chartType: ChartState = .rep
    @Published var trainingType: TrainingType
    @Published private(set) var chartData: [Double] = []
    
    private var workoutWithType: Set<Workout> = []
    private var historyWorkouts: [Workout] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(trainingType: TrainingType) {
        self.trainingType = trainingType
        
        Publishers.CombineLatest3($rawWorkouts, $timePeriod, $chartType)
            .sink { [weak self] workouts, period, type in
                self?.recalculateData(for: workouts, in: period, by: type)
            }
            .store(in: &cancellables)
    }
    
    private func recalculateData(for workouts: Set<Workout>, in period: TimePeriod, by type: ChartState) {
        DispatchQueue.main.async {
            self.filterWorkoutType(for: workouts, by: self.trainingType)
            self.historyWorkouts = self.setHistoryWorkouts(from: self.workoutWithType)
            self.calculateChartData(for: self.workoutWithType, in: period, by: type)
        }
    }
    
    private func filterWorkoutType(for workouts: Set<Workout>, by type: TrainingType) {
        self.workoutWithType = workouts.filter { $0.exerciseSet?.trainingType == self.trainingType }
    }
    
    private func setHistoryWorkouts(from workouts: Set<Workout>) -> [Workout] {
        return workouts.sorted { $0.date ?? Date() > $1.date ?? Date() }
    }
    
    private func calculateChartData(for workouts: Set<Workout>, in period: TimePeriod, by type: ChartState) {
        let filtredByPeriod = filterLast(workouts, by: period)
        let sortedArrayOfArrays = self.bucketSort(filtredByPeriod, by: period)
        
        switch type {
        case .accuracy:
            self.calculateChartAccuracy(for: sortedArrayOfArrays, in: period)
        case .rep:
            self.calculateChartReps(for: sortedArrayOfArrays, in: period)
        case .session:
            self.calculateChartSessions(for: sortedArrayOfArrays, in: period)
        }
    }
    
    private func calculateChartSessions(for workouts: [[Workout]], in period: TimePeriod) {
        var resultData: [Double] = self.createResultData(by: period)
        
        var resultArray: [Double] = []
        for arr in workouts {
            resultArray.append(Double(arr.count))
        }
        
        var index = 0
        for i in (resultData.count - resultArray.count)..<resultData.count {
            resultData[i] = resultArray[index]
            index += 1
        }
        self.chartData = resultData
    }
    
    private func calculateChartReps(for workouts: [[Workout]], in period: TimePeriod) {
        var resultData: [Double] = self.createResultData(by: period)
        
        var resultArray: [Double] = []
        for arr in workouts {
            resultArray.append(arr.reduce(0, { partialResult, workout in
                partialResult + Double(workout.exerciseSet?.count ?? 0)
            }))
        }
        
        var index = 0
        for i in (resultData.count - resultArray.count)..<resultData.count {
            resultData[i] = resultArray[index]
            index += 1
        }
        self.chartData = resultData
    }
    
    private func calculateChartAccuracy(for workouts: [[Workout]], in period: TimePeriod) {
        func average(_ arr: [Workout]) -> Double {
            guard arr.count != 0 else { return 0 }
            let sum = arr.reduce(0) { partialResult, workout in
                partialResult + (workout.exerciseSet?.metricPoint?.quality ?? 0)
            }
            return sum / Double(arr.count)
        }
        
        var mutableWorkouts = workouts
        filterNil(&mutableWorkouts)
        
        var resultArray: [Double] = []
        for arr in mutableWorkouts {
            resultArray.append((average(arr) * 100).rounded() / 100)
        }
        
        var resultData: [Double] = self.createResultData(by: period)
        
        var index = 0
        for i in (resultData.count - resultArray.count)..<resultData.count {
            resultData[i] = resultArray[index]
            index += 1
        }
        self.chartData = resultData
    }
    
    private func createResultData(by period: TimePeriod) -> [Double] {
        switch period {
        case .week:
            return Array(repeating: 0, count: 7)
        case .month:
            return Array(repeating: 0, count: 4)
        case .year:
            return Array(repeating: 0, count: 12)
        case .allTime:
            return Array(repeating: 0, count: 4)
        }
    }
    
    private func bucketSort(_ set: Set<Workout>, by period: TimePeriod) -> [[Workout]] {
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
        
        let groupedDictionary = Dictionary(grouping: set) { (workout) -> Date in
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
        return sortedArrayOfArrays
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
    
    private func filterLast(_ rawWorkouts: Set<Workout>, by period: TimePeriod) -> Set<Workout> {
        guard period != .allTime else { return rawWorkouts }
        
        guard let startDate = calculateStartDate(for: period) else { return rawWorkouts }
        return rawWorkouts.filter { workout in
            guard let workoutDate = workout.date else { return false }
            return workoutDate >= startDate
        }
    }
    
    private func filterNil(_ rawWorkouts: inout [[Workout]]) {
        for i in 0..<rawWorkouts.count {
            rawWorkouts[i] = rawWorkouts[i].filter { $0.exerciseSet?.metricPoint?.quality != -1.0 }
        }
    }
    
    func getHistoryWorkouts() -> [Workout] {
        return Array(historyWorkouts.prefix(4))
    }
}
