class ExerciseAnalyzerFactory {
    static func create(trainingType: TrainingType, userWeight: Double) -> ExerciseAnalyzer {
        switch trainingType {
        case .pushup:
            return PushUpAnalyzer(userWeight: userWeight)
        case .squat:
            return SquatAnalyzer(userWeight: userWeight)
        case .plank:
            return PlankAnalyzer(userWeight: userWeight)
        }
    }
}
