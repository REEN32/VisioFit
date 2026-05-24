class ExerciseAnalyzerFactory {
    static func create(trainingType: TrainingType) -> ExerciseAnalyzer {
        switch trainingType {
        case .pushup:
            return PushUpAnalyzer()
        case .squat:
            fatalError()
        case .plank:
            return PlankAnalyzer()
        }
    }
}
