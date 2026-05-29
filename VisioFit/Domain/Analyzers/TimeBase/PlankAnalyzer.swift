import Foundation
import CoreGraphics

class PlankAnalyzer: ExerciseAnalyzer {
    private(set) var accuracy: Int?
    private(set) var count: Int = 0
    private(set) var badCount: Int = 0
    private(set) var goodCount: Int = 0
    private(set) var perfectCount: Int = 0
    private(set) var burnedCalories: Double = 0
    
    private let userWeight: Double
    
    private let timeStap = 0.05
    private var accuracyArray: [Int] = []
    
    private var frameCounter: Double = 0.0
    
    init(userWeight: Double = 70.0) {
        self.userWeight = userWeight
    }
    
    func analyze(pose: BodyPoseData) {
        guard let shoulders = pose.shoulders, let shoulder = shoulders.first,
              let knees = pose.knees, let knee = knees.first,
              let root = pose.root else {
            self.accuracy = 0
            return
        }
        
        let hipAngle = self.calculateDegrees(shoulder: shoulder, root: root, knee: knee)
        
        var shouldersDiff: Double = 0.0
        if shoulders.count >= 2 {
            let percent = Double(shoulders[0].y) / Double(shoulders[1].y)
            shouldersDiff = (percent * 100) - 100
        }

        let isPlankActive = hipAngle >= 165 && hipAngle <= 185
        
        if isPlankActive {
            self.calculateAccuracy(shouldersDiff: shouldersDiff, hipAngle: hipAngle)
            
            self.frameCounter += timeStap
            
            if self.frameCounter >= 1.0 {
                self.frameCounter = 0.0
                self.count += 1
                
                self.updateAverageAccuracy()
                
                let met = 5.5
                let caloriesPerMinute = (met * 3.5 * userWeight) / 200.0
                let caloriesPerSecond = caloriesPerMinute / 60.0
                let accuracyModifier = Double(self.accuracy ?? 100) / 100.0
                self.burnedCalories += caloriesPerSecond * accuracyModifier
                
                if let currentAccuracy = self.accuracy {
                    switch currentAccuracy {
                    case 0...60:
                        self.badCount += 1
                    case 61...85:
                        self.goodCount += 1
                    case 86...100:
                        self.perfectCount += 1
                    default:
                        break
                    }
                }
            }
        } else {
            self.frameCounter = 0.0
            self.accuracy = 0
            self.accuracyArray.removeAll()
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
    
    private func calculateAccuracy(shouldersDiff: Double, hipAngle: CGFloat) {
        var currentAccuracy: Double = 100.0
        
        if abs(shouldersDiff) > 5.0 {
            currentAccuracy -= (abs(shouldersDiff) - 5.0) * 2.5
        }
        
        let deviationFromStraight = abs(Double(hipAngle) - 180.0)
        if deviationFromStraight > 5.0 {
            currentAccuracy -= (deviationFromStraight - 5.0) * 3.0
        }
        
        let finalAccuracy = max(0, min(Int(currentAccuracy), 100))
        self.accuracyArray.append(finalAccuracy)
    }
    
    private func updateAverageAccuracy() {
        guard !self.accuracyArray.isEmpty else { return }
        let sum = self.accuracyArray.reduce(0, +)
        let average = Double(sum) / Double(self.accuracyArray.count)
        self.accuracy = Int(average)
        self.accuracyArray.removeAll()
    }

    func reset() {
        self.count = 0
        self.badCount = 0
        self.goodCount = 0
        self.perfectCount = 0
        self.frameCounter = 0.0
        self.burnedCalories = 0
        self.accuracy = nil
        self.accuracyArray.removeAll()
    }
}
