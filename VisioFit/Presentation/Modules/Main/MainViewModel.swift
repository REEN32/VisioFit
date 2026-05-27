import Foundation
import Combine


enum ChartType: String {
    case kkal = "килокалории"
    case steps = "шаги"
    case range = "киллометры"
    case time = "время тренировок"
}

class MainViewModel: ObservableObject {
    @Published var rawWorkouts: Set<Workout> = []
    @Published var chartType: ChartType = .kkal
    @Published var steps: [Double] = []
    @Published var distance: [Double] = []
    @Published var calories: [Double] = []
    
    @Published private(set) var chartData: [Double] = []
    private var cancellables = Set<AnyCancellable>()
    
    var chartTitle: String {
        "неделя (\(self.chartType.rawValue))"
    }
    
    var todayWorkoutsDuration: Double {
        let calendar = Calendar.current
        let now = Date()
        
        let todayWorkouts = rawWorkouts.filter { workout in
            guard let workoutDate = workout.date else { return false }
            return calendar.isDateInToday(workoutDate)
        }
        
        let totalDuration = todayWorkouts.reduce(0.0) { partialResult, workout in
            partialResult + Double(workout.duration)
        }
        
        return totalDuration
    }
    
    init() {
        Publishers.CombineLatest4($rawWorkouts, $chartType, $steps, Publishers.CombineLatest($distance, $calories))
            .sink { [weak self] workouts, chartType, steps, remaining in
                let (distance, calories) = remaining
                self?.steps = steps
                self?.distance = distance
                self?.calories = calories
                self?.recalculateCharts(for: chartType, workouts: workouts)
            }
            .store(in: &cancellables)
    }
    
    private func recalculateCharts(for chartType: ChartType, workouts: Set<Workout>) {
        switch chartType {
        case .kkal: self.chartData = self.calories
        case .range: self.chartData = self.distance
        case .steps: self.chartData = self.steps
        case .time: self.chartData = self.setTimeChart(workouts: workouts)
        }
    }
    
    private func setTimeChart(workouts: Set<Workout>) -> [Double] {
        let filtredByPeriod = filterLastWeek(workouts)
        let sortedArrayOfArrays = self.bucketSort(filtredByPeriod)
        
        var resultData: [Double] = Array(repeating: 0, count: 7)
        var resultArray: [Double] = []
        for arr in sortedArrayOfArrays {
            resultArray.append(arr.reduce(0, { partialResult, workout in
                partialResult + Double(workout.duration)
            }))
        }
        
        var index = 0
        for i in (resultData.count - resultArray.count)..<resultData.count {
            resultData[i] = resultArray[index]
            index += 1
        }
        return resultData
    }
    
    private func bucketSort(_ set: Set<Workout>) -> [[Workout]] {
        let calendar = Calendar.current
        let component: Calendar.Component = .day
        
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
    
    private func filterLastWeek(_ rawWorkouts: Set<Workout>) -> Set<Workout> {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) else { return rawWorkouts }
        return rawWorkouts.filter { workout in
            guard let workoutDate = workout.date else { return false }
            return workoutDate >= startDate
        }
    }
    
    func calculatePercentCallories(actualCal cal: Double, for user: User) -> Double {
        return min(((cal / Double(user.kkalGoal))) * 100, 100)
    }
}
