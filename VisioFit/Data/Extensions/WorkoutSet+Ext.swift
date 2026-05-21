extension WorkoutSet {
    var trainingType: TrainingType {
        switch self.name {
        case "Отжимания": return .pushup
        case "Планка": return .plank
        case "Приседания": return .squat
        default: return .pushup
        }
    }
}
