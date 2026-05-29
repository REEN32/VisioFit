import Foundation
import CoreGraphics

class SquatAnalyzer: ExerciseAnalyzer {
    private(set) var accuracy: Int?
    private(set) var count: Int = 0
    private(set) var badCount: Int = 0
    private(set) var goodCount: Int = 0
    private(set) var perfectCount: Int = 0
    private(set) var burnedCalories: Double = 0
    
    private let userWeight: Double
    
    private let timeStap = 0.05
    private var accuracyArray: [Int] = []
    private var lastAngle: (left: CGFloat, right: CGFloat) = (180, 180)
    
    private var isSquatUp: Bool = true
    
    init(userWeight: Double = 70.0) {
        self.userWeight = userWeight
    }
    
    func analyze(pose: BodyPoseData) {
        guard let shoulders = pose.shoulders, let shoulder = shoulders.first,
              let root = pose.root,
              let knees = pose.knees,
              let ankles = pose.ankles else { return }
        

        if knees.count < 2 || ankles.count < 2 { return }
        
        let leftKneeAngle = self.calculateDegrees(p1: root, p2: knees[1], p3: ankles[1])
        let rightKneeAngle = self.calculateDegrees(p1: root, p2: knees[0], p3: ankles[0])
        let currentKneeAngle = (leftKneeAngle + rightKneeAngle) / 2
        
        let backAngle = self.calculateDegrees(p1: shoulder, p2: root, p3: knees[0])
        
        var shouldersDiff: Double = 0.0
        if shoulders.count >= 2 {
            let percent = Double(shoulders[0].y) / Double(shoulders[1].y)
            shouldersDiff = (percent * 100) - 100
        }
        
        let speed = self.calculateSpeed(currentAngle: (leftKneeAngle, rightKneeAngle), previousAngle: self.lastAngle, timeStamp: self.timeStap)
        
        self.lastAngle = (left: leftKneeAngle, right: rightKneeAngle)
        
        self.calculateAccuracy(shouldersDiff: shouldersDiff, kneeAngles: (leftKneeAngle, rightKneeAngle), backAngle: backAngle, speed: speed)
        
        if self.accuracyArray.count > Int((0.3 / self.timeStap).rounded(.up)) {
            let sum = self.accuracyArray.reduce(0, +)
            let average = Double(sum) / Double(self.accuracyArray.count)
            self.accuracy = average < 0 ? 0 : Int(average)
            self.accuracyArray.removeAll()
        }
        
        if currentKneeAngle < 105 && isSquatUp {
            self.isSquatUp = false
        }
        
        if currentKneeAngle > 165 && !isSquatUp {
            self.isSquatUp = true
            self.count += 1
            
            let met = 10.0
            let caloriesPerMinute = (met * 3.5 * userWeight) / 200.0
            let caloriesPerSecond = caloriesPerMinute / 60.0
            let caloriesForOneRep = caloriesPerSecond * 2.5
            let accuracyModifier = Double(self.accuracy ?? 100) / 100.0
            self.burnedCalories += caloriesForOneRep * accuracyModifier
            
            guard let accuracy = self.accuracy else { return }
            switch accuracy {
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
    
    private func calculateDegrees(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGFloat {
        var angle = abs((atan2(p1.y - p2.y, p1.x - p2.x) - atan2(p3.y - p2.y, p3.x - p2.x)) * 180 / .pi)
        if angle > 180 {
            angle = 360 - angle
        }
        return angle
    }
    
    private func calculateSpeed(currentAngle: (left: CGFloat, right: CGFloat), previousAngle: (left: CGFloat, right: CGFloat), timeStamp: Double) -> Double {
        let leftSpeed = abs(currentAngle.left - previousAngle.left) / timeStamp
        let rightSpeed = abs(currentAngle.right - previousAngle.right) / timeStamp
        return (leftSpeed + rightSpeed) / 2
    }
    
    private func calculateAccuracy(shouldersDiff: Double, kneeAngles: (left: CGFloat, right: CGFloat), backAngle: CGFloat, speed: Double) {
        var currentAccuracy: Double = 100
        
        if abs(shouldersDiff) > 5.0 {
            currentAccuracy -= (abs(shouldersDiff) - 5.0) * 2.0
        }
        
        let kneesDiff = abs(kneeAngles.left - kneeAngles.right)
        if kneesDiff > 12.0 {
            currentAccuracy -= (kneesDiff - 12.0) * 0.8
        }
        
        if backAngle < 45.0 {
            currentAccuracy -= (45.0 - backAngle) * 2.0
        }
        
        if speed > 80 {
            currentAccuracy -= (speed - 80) * 0.1
        }
        
        let finalAccuracy = max(0, min(Int(currentAccuracy), 100))
        self.accuracyArray.append(finalAccuracy)
    }
    
    func reset() {
        self.count = 0
        self.badCount = 0
        self.goodCount = 0
        self.perfectCount = 0
        self.burnedCalories = 0
        self.accuracy = nil
        self.accuracyArray.removeAll()
        self.isSquatUp = true
    }
}
