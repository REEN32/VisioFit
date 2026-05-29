protocol ExerciseAnalyzer {
    var badCount: Int { get }
    var goodCount: Int { get }
    var perfectCount: Int { get }
    var count: Int { get }
    var accuracy: Int? { get }
    var burnedCalories: Double { get }
    
    func analyze(pose: BodyPoseData)
    func reset()
}
