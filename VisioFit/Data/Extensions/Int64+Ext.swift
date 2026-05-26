import Foundation

extension Int64 {
    var workoutTime: String {
        let min = self / 60
        let sec = self % 60
        return "\(min):\(sec)"
    }
}
