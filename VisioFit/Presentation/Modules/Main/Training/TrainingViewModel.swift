import Combine
import Foundation
import CoreData

class TrainingViewModel: ObservableObject {
    @Published var reps: Int = 0
    var totalReps: Int = 0
    var badReps: Int = 0
    var goodReps: Int = 0
    var perfectReps: Int = 0
    var burnedCalories: Double = 0
    @Published var currentAccuracy: Int?
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
    
    var burnedCaloriesView: Double {
        (self.burnedCalories * 100).rounded() / 100
    }
    
    var averageAccuracy: Int? {
        accuracyArray.isEmpty ? nil : Int(accuracyArray.reduce(0, +) / Double(accuracyArray.count))
    }
    
    init(cameraVM: CameraViewModel) {
        self.cameraVM = cameraVM
        
        cameraVM.$accuracy
            .compactMap { $0 }
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
        
        cameraVM.$badCount
            .sink { [weak self] badCount in
                self?.badReps = badCount
            }
            .store(in: &cancellables)
        
        cameraVM.$goodCount
            .sink { [weak self] goodCount in
                self?.goodReps = goodCount
            }
            .store(in: &cancellables)
        
        cameraVM.$perfectCount
            .sink { [weak self] perfectCount in
                self?.perfectReps = perfectCount
            }
            .store(in: &cancellables)
        
        cameraVM.$burnedCallories
            .sink { [weak self] burnedCalories in
                self?.burnedCalories = burnedCalories
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        startTimerDate = Date()
        self.accuracyArray.removeAll()
        
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
