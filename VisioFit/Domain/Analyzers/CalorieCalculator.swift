import Foundation

struct CalorieCalculator {
    enum ExerciseType {
        case pushUp
        case plank
        case squat
        
        var met: Double {
            switch self {
            case .plank: return 3.5
            case .pushUp: return 4.0
            case .squat: return 5.0
            }
        }
    }
    
    static func caloriesPerSecond(for type: ExerciseType, userWeight: Double = 70.0) -> Double {
        let caloriesPerMinute = (type.met * 3.5 * userWeight) / 200.0
        return caloriesPerMinute / 60.0
    }
}
