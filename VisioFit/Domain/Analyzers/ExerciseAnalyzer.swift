protocol ExerciseAnalyzer {
    var count: Int { get }
    var accuracy: Int { get }
    
    func analyze(pose: BodyPoseData)
    func reset()
}
