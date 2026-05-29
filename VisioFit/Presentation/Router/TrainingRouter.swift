import SwiftUI

struct TrainingRouter: View {
    @State var trainingScreen: TrainingScreen
    var onFinish: () -> Void
    
    @StateObject private var cameraViewModel: CameraViewModel
    @StateObject private var trainingViewModel: TrainingViewModel
    
    private var trainingType: TrainingType
    private let workoutSet: WorkoutSet
    private let isCV: Bool
    
    init(trainingType: TrainingType, workoutSet: WorkoutSet, isCV: Bool, userWeight: Double, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        self.trainingType = trainingType
        
        let cameraVM: CameraViewModel = CameraViewModel(analyzer: ExerciseAnalyzerFactory.create(trainingType: trainingType, userWeight: userWeight))
        self._cameraViewModel = StateObject(wrappedValue: cameraVM)
        
        let trainingVM = TrainingViewModel(cameraVM: cameraVM)
        self._trainingViewModel = StateObject(wrappedValue: trainingVM)
        
        self.workoutSet = workoutSet
        self.isCV = isCV
        if isCV {
            self.trainingScreen = .cvProcess
        } else {
            self.trainingScreen = .handleProcess
        }
    }
    
    var body: some View {
        Group {
            switch trainingScreen {
            case .rest:
                TrainingRestView(trainingScreen: $trainingScreen, workoutSet: workoutSet, isCV: isCV)
            case .cvProcess:
                TrainingProcessView(trainingScreen: $trainingScreen, cameraViewModel: cameraViewModel, workoutSet: workoutSet)
            case .handleProcess:
                TrainingHandleView(trainingScreen: $trainingScreen, workoutSet: workoutSet)
            case .complete:
                TrainingCompleteView(workoutSet: workoutSet, onDismiss: onFinish)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(trainingViewModel)
    }
}
//
//#Preview {
//    TrainingRouter()
//}
