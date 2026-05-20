import SwiftUI

struct TrainingProcessView: View {
    @Binding var trainingScreen: TrainingScreen
    
    @ObservedObject private var cameraViewModel: CameraViewModel
    
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    
    init(trainingScreen: Binding<TrainingScreen>, cameraViewModel: CameraViewModel) {
        self._trainingScreen = trainingScreen
        self.cameraViewModel = cameraViewModel
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .lastTextBaseline) {
                            Text("Приседания")
                                .headText(fontSize: 26)
                            Spacer()
                            Text("3 подход")
                                .headText(fontSize: 18)
                        }
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(trainingViewModel.totalReps)")
                                .headText(fontSize: 60)
                            Text("повторений")
                                .headText(fontSize: 22, weight: .medium)
                        }
                        RepeatCountLines(count: trainingViewModel.totalReps, target: 12)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .background(Color.accentOrange)
                    
                    CameraPreview(session: cameraViewModel.session)
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height * 0.6)
                    .overlay(alignment: .bottom) {
                        HStack {
                            DefaultIcon(iconName: "info.circle", maxWidth: 40, maxHeight: 40)
                            Spacer()
                            HStack(spacing: 0) {
                                Spacer()
                                Text("Держите руки ровнее")
                                    .accentDescription(fontSize: 16)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .orangeTintBlock()
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                    }
                    
                    VStack(spacing: 15) {
                        VStack(spacing: 10) {
                            Text("\(trainingViewModel.currentAccuracy)% точности")
                                .accuracyText(value: Double(trainingViewModel.currentAccuracy))
                            AccuracyBar(percent: Double(trainingViewModel.currentAccuracy))
                                .frame(height: 10)
                        }
                        .padding(15)
                        .mainBlock()
                        
                        DefaultButton(label: "Закончить подход") {
                            self.trainingViewModel.stopTimer()
                            trainingScreen = .rest
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                }
                
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            cameraViewModel.start()
            trainingViewModel.startTimer()
        }
        .onDisappear {
            cameraViewModel.stop()
        }
    }
}
//
//#Preview {
//    TrainingProcessView(trainingScreen: .constant(.cvProcess))
//}
