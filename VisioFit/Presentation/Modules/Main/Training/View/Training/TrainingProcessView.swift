import SwiftUI

struct TrainingProcessView: View {
    @Binding var trainingScreen: TrainingScreen
    
    @ObservedObject private var cameraViewModel: CameraViewModel
    
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    @Environment(\.managedObjectContext) private var context
    
    @State private var countdown: Int = 5
    @State private var isCountingDown: Bool = true
    
    private var workoutSet: WorkoutSet
    
    init(trainingScreen: Binding<TrainingScreen>, cameraViewModel: CameraViewModel, workoutSet: WorkoutSet) {
        self._trainingScreen = trainingScreen
        self.cameraViewModel = cameraViewModel
        self.workoutSet = workoutSet
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .lastTextBaseline) {
                            Text(workoutSet.name ?? "Неизвесное")
                                .headText(fontSize: 26)
                            Spacer()
                            Text("\(workoutSet.completedApproach) подход")
                                .headText(fontSize: 18)
                        }
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(trainingViewModel.reps)")
                                .headText(fontSize: 60)
                            Text("повторений")
                                .headText(fontSize: 22, weight: .medium)
                        }
                        RepeatCountLines(count: trainingViewModel.reps, target: Int(workoutSet.requirementReps))
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
        .overlay {
            if isCountingDown {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    Text(countdown > 0 ? "\(countdown)" : "СТАРТ!")
                        .headText(fontSize: 60, weight: .bold)
                }
            }
        }
        .onAppear {
            cameraViewModel.reset()
            
            cameraViewModel.start()
            startCountdown(for: countdown)
        }
        .onDisappear {
            cameraViewModel.stop()
            trainingViewModel.updateReps()
        }
        .onChange(of: trainingViewModel.reps) { _, newValue in
            if newValue >= workoutSet.requirementReps {
                self.trainingViewModel.stopTimer()
                trainingScreen = .rest
            }
        }
    }
    
    private func startCountdown(for duration: Int) {
        if duration > 0 {
            self.countdown = duration
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startCountdown(for: duration - 1)
            }
        } else {
            self.countdown = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isCountingDown = false
                
                cameraViewModel.reset()
                trainingViewModel.startTimer()
                trainingViewModel.addApproach(workoutSet: workoutSet, context: context)
            }
        }
    }
}
