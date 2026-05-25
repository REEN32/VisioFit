import Foundation

class PlankAnalyzer: ExerciseAnalyzer {
    private(set) var accuracy: Int?
    private(set) var count: Int = 0
    private(set) var badCount: Int = 0
    private(set) var goodCount: Int = 0
    private(set) var perfectCount: Int = 0
    
    private let timeStap = 0.05
    private var accuracyArray: [Int] = []
    private var isPlank: Bool = false
    
    func analyze(pose: BodyPoseData) {
        guard let sholders = pose.shoulders else { return }
        guard let knees = pose.knees else { return }
        guard let root = pose.root else { return }
        
        if let shoulder = sholders.first, let knee = knees.first {

            let angle = self.calculateDegrees(shoulder: shoulder, root: root, knee: knee)
            
            if angle > 175 && angle < 185 {
                self.isPlank = true
            }
            
//            self.calculateAccuracy(shouldersDiff: diff, angle: self.lastAngle, speed: speed)
        } else {
            return
        }
        
        if self.accuracyArray.count > Int((0.3 / self.timeStap).rounded(.up)) {
            let sum = self.accuracyArray.reduce(0, +)
            let average = Double(sum) / Double(self.accuracyArray.count)
            self.accuracy = average < 0 ? 0 : Int(average)
            self.accuracyArray.removeAll()
        }
        
        if (isPlank) { // Балванка
            self.isPlank = false
            self.count += 1
            guard let accuracy = self.accuracy else { return }
            switch accuracy {
            case 0...60:
                self.badCount += 1
            case 61...85:
                self.goodCount += 1
            case 86...100:
                self.perfectCount += 1
            default:
                _ = 0
            }
        }
    }
    
    private func calculateDegrees(shoulder: CGPoint, root: CGPoint, knee: CGPoint) -> CGFloat {
        let angleToShoulder = atan2(shoulder.y - root.y, shoulder.x - root.x)
        let angleToKnee = atan2(knee.y - root.y, knee.x - root.x)
        
        var angle = abs((angleToShoulder - angleToKnee) * 180 / .pi)
        
        if angle > 180 {
            angle = 360 - angle
        }
        
        return angle
    }
    
    private func calculateAccuracy(shouldersDiff: Double, angle: (left: CGFloat, right: CGFloat), speed: Double) {
        var currentAccuracy: Double = 100
        if abs(shouldersDiff) > 5.0 {
            currentAccuracy -= (abs(shouldersDiff) - 5.0) * 2.5
        }
        
        if abs(angle.left - angle.right) > 10.0 {
            let angleDiff = abs(angle.left - angle.right)
            currentAccuracy -= (angleDiff - 10.0) * 0.5
        }
        // Добавить проверку на слишком глубокие отжимание angle < 90
        
        self.accuracyArray.append(Int(currentAccuracy))
    }

    func reset() {
        self.count = 0
        self.accuracy = nil
    }
}
