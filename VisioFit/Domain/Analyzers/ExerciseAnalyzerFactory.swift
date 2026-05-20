class ExerciseAnalyzerFactory {
    static func create(trainingType: TrainingType) -> ExerciseAnalyzer {
        switch trainingType {
        case .pushup:
            return PushUpAnalyzer()
        case .даун:
            fatalError()
        case .планка:
            fatalError()
        }
    }
}
