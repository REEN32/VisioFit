import Foundation

class PushUpAnalyzer: ExerciseAnalyzer {
    private(set) var accuracy: Int = 100
    private(set) var count: Int = 0
    
    private let timeStap = 0.05
    private var accuracyArray: [Int] = []
    private var lastAngle: (left: CGFloat, right: CGFloat) = (180, 180)
    private var isPushUp: Bool = true
    
    func analyze(pose: BodyPoseData) {
        guard let sholders = pose.shoulders else { return }
        guard let elbows = pose.elbows else { return }
        guard let wrists = pose.wrists else { return }
        if sholders.count < 2 && elbows.count < 2 && wrists.count < 2 {
        } else {
            let percent = Double(sholders[0].y) / Double(sholders[1].y)
            let diff = (percent * 100) - 100

            let leftAngle = self.calculateDegrees(wrists: wrists, elbows: elbows, sholders: sholders, left: true)
            let rightAngle = self.calculateDegrees(wrists: wrists, elbows: elbows, sholders: sholders, left: false)
            
            let speed = self.calculateSpeed(currentAngle: (leftAngle, rightAngle), previousAngle: self.lastAngle, timeStamp: self.timeStap)
            
            self.lastAngle = (left: leftAngle, right: rightAngle)
            
            self.calculateAccuracy(shouldersDiff: diff, angle: self.lastAngle, speed: speed)
        }
        
        if self.accuracyArray.count > Int((0.3 / self.timeStap).rounded(.up)) {
            let sum = self.accuracyArray.reduce(0, +)
            let average = Double(sum) / Double(self.accuracyArray.count)
            self.accuracy = average < 0 ? 0 : Int(average)
            self.accuracyArray.removeAll()
        }
        
        if (Double(self.lastAngle.left + self.lastAngle.right) / 2) < 100 && isPushUp {
            self.count += 1
            self.isPushUp = false
        }
        
        if (Double(self.lastAngle.left + self.lastAngle.right) / 2) > 150 {
            self.isPushUp = true
        }
    }
    
    private func calculateDegrees(wrists: [CGPoint], elbows: [CGPoint], sholders: [CGPoint], left: Bool) -> CGFloat {
        let side = left ? 1 : 0
        var angle = abs((atan2(wrists[side].y - elbows[side].y, wrists[side].x - elbows[side].x) - atan2(sholders[side].y - elbows[side].y, sholders[side].x - elbows[side].x)) * 180 / .pi)
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
        
        if speed > 60 {
            currentAccuracy -= (speed - 60) * 0.1
        }
        
        self.accuracyArray.append(Int(currentAccuracy))
    }

    func reset() {
        self.count = 0
        self.accuracy = 100
    }
}
