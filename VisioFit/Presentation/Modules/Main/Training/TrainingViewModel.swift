import Combine
import Foundation
import CoreData

class TrainingViewModel: ObservableObject {
    @Published var reps: Int = 0
    var totalReps: Int = 0
    @Published var currentAccuracy: Int = 100
    @Published var accuracyArray: [Double] = []
    @Published var trainingTime: TimeInterval = 0
    @Published var restTime: TimeInterval = 20
    
    private var cameraVM: CameraViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var timer: AnyCancellable?
    private var restTimer: AnyCancellable?
    private var startTimerDate: Date?
    
    var timeString: String {
        let minutes = Int(trainingTime) / 60
        let seconds = Int(trainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var restTimeString: String {
        let minutes = Int(restTime) / 60
        let seconds = Int(restTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var averageAccuracy: Int {
        accuracyArray.isEmpty ? 0 : Int(accuracyArray.reduce(0, +) / Double(accuracyArray.count))
    }
    
    init(cameraVM: CameraViewModel) {
        self.cameraVM = cameraVM
        
        cameraVM.$accuracy
            .sink { [weak self] accuracy in
                self?.currentAccuracy = accuracy
                self?.accuracyArray.append(Double(accuracy))
            }
            .store(in: &cancellables)
        
        cameraVM.$count
            .sink { [weak self] count in
                self?.reps = count
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        startTimerDate = Date()
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateDuration()
            }
    }
    
    private func updateDuration() {
        guard let startTimerDate else { return }
        self.trainingTime += Date().timeIntervalSince(startTimerDate)
        self.startTimerDate = Date()
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func startRestTimer() {
        restTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.restTime > 0 {
                    self.restTime -= 1
                } else {
                    self.stopRestTimer()
                }
            }
    }
    
    func stopRestTimer() {
        restTimer?.cancel()
    }
    
    func addRestTime(_ seconds: Int) {
        self.restTime += Double(seconds)
    }
    
    func addApproach(workoutSet: WorkoutSet, context: NSManagedObjectContext) {
        workoutSet.completedApproach += 1
        do {
            try context.save()
        } catch {
            print("Training workout save error: \(error)")
        }
    }
    
    func cleanApproach(workoutSet: WorkoutSet, context: NSManagedObjectContext) {
        workoutSet.completedApproach = 0
        
        do {
            try context.save()
        } catch {
            print("Training workout save error: \(error)")
        }
    }
    
    func updateReps() {
        self.totalReps += self.reps
        self.reps = 0
        self.cameraVM.count = 0
    }
    
    func updateRestTime() {
        self.restTime = 20
    }
}
