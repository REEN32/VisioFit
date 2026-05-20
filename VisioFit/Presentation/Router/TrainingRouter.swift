import SwiftUI

struct TrainingRouter: View {
    @State var trainingScreen: TrainingScreen
    var onFinish: () -> Void
    
    @StateObject private var cameraViewModel: CameraViewModel
    @StateObject private var trainingViewModel: TrainingViewModel
    
    private var trainingType: TrainingType
    
    init(trainingScreen: TrainingScreen, trainingType: TrainingType, onFinish: @escaping () -> Void) {
        self.trainingScreen = trainingScreen
        self.onFinish = onFinish
        self.trainingType = trainingType
        
        let cameraVM: CameraViewModel = CameraViewModel(analyzer: ExerciseAnalyzerFactory.create(trainingType: trainingType))
        self._cameraViewModel = StateObject(wrappedValue: cameraVM)
        
        let trainingVM = TrainingViewModel(cameraVM: cameraVM)
        self._trainingViewModel = StateObject(wrappedValue: trainingVM)
    }
    
    var body: some View {
        Group {
            switch trainingScreen {
            case .rest:
                TrainingRestView(trainingScreen: $trainingScreen)
            case .cvProcess:
                TrainingProcessView(trainingScreen: $trainingScreen, cameraViewModel: cameraViewModel)
            case .handleProcess:
                TrainingHandleView(trainingScreen: $trainingScreen)
            case .complete:
                TrainingCompleteView(onDismiss: onFinish)
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
