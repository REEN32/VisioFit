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
            self.historyWorkouts = self.setHistoryWorkouts(from: workouts)
        }
    }
    
    private func setHistoryWorkouts(from workouts: Set<Workout>) -> [Workout] {
        let workoutNeedType = workouts.filter { $0.exerciseSet?.trainingType == self.trainingType }
        return workoutNeedType.sorted { $0.date ?? Date() > $1.date ?? Date() }
    }
    
    func getHistoryWorkouts() -> [Workout] {
        return Array(historyWorkouts.prefix(4))
    }
}
