import SwiftUI

struct TrainingRouter: View {
    @State var trainingScreen: TrainingScreen
    var onFinish: () -> Void
    
    var body: some View {
        Group {
            switch trainingScreen {
            case .rest:
                TrainingRestView(trainingScreen: $trainingScreen)
            case .cvProcess:
                TrainingProcessView(trainingScreen: $trainingScreen)
            case .handleProcess:
                TrainingHandleView(trainingScreen: $trainingScreen)
            case .complete:
                TrainingCompleteView(onDismiss: onFinish)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
//
//#Preview {
//    TrainingRouter()
//}
