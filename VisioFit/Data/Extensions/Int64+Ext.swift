import Foundation

extension Int64 {
    var workoutTime: String {
        let min = self / 60
        let sec = self % 60
        if sec < 10 {
            return "\(min):0\(sec)"
        }
        return "\(min):\(sec)"
    }
}
