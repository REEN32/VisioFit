protocol ExerciseAnalyzer {
    var badCount: Int { get }
    var goodCount: Int { get }
    var perfectCount: Int { get }
    var count: Int { get }
    var accuracy: Int? { get }
    
    func analyze(pose: BodyPoseData)
    func reset()
}
