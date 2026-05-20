import Combine
import Foundation

class TrainingViewModel: ObservableObject {
    @Published var totalReps: Int = 0
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
                self?.totalReps = count
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
        self.trainingTime = Date().timeIntervalSince(startTimerDate)
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
}
