import SwiftUI

struct TrainingRestView: View {
    @State private var showWindow: Bool = false
    @State private var selectedMinutesIndex: Int = 0
    
    @Binding var trainingScreen: TrainingScreen
    
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    
    private var workoutSet: WorkoutSet
    private var isCV: Bool
    
    init(trainingScreen: Binding<TrainingScreen>, workoutSet: WorkoutSet, isCV: Bool) {
        self._trainingScreen = trainingScreen
        self.workoutSet = workoutSet
        self.isCV = isCV
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Упражнение \(workoutSet.completedApproach)/\(workoutSet.approach)")
                                    .headText(fontSize: 24, weight: .bold)
                                Text(workoutSet.name ?? "Неизвестно")
                                    .headText(fontSize: 36)
                                Text(trainingViewModel.timeString)
                                    .headText(fontSize: 56)
                                Text("время тренировки")
                                    .headText(fontSize: 20, weight: .medium)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .background(Color.accentOrange)
                    
                    VStack(alignment: .center, spacing: 20) {
                        Text("Отдохните")
                            .textCase(.uppercase)
                            .headText()
                        
                        Text(trainingViewModel.restTimeString)
                            .headText(fontSize: 80)
                            .monospacedDigit()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        DefaultButton(label: "Добавить вермя") {
                            showWindow = true
                        }
                        DefaultButton(label: "Следующий подход") {
                            trainingViewModel.stopRestTimer()
                            if workoutSet.approach <= workoutSet.completedApproach {
                                trainingScreen = .complete
                            } else if isCV {
                                trainingScreen = .cvProcess
                            } else {
                                trainingScreen = .handleProcess
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .frame(maxHeight: proxy.size.height * 0.1)
                }
                if showWindow {
                    VStack() {
                        timeWindow()
                            .frame(maxWidth: proxy.size.width / 1.4, maxHeight: proxy.size.height / 2.5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                }
            }
        }
        .onAppear {
            trainingViewModel.updateRestTime()
            trainingViewModel.startRestTimer()
        }
        .onChange(of: trainingViewModel.restTime) { oldValue, newValue in
            if newValue == 0 {
                DispatchQueue.main.async {
                    trainingViewModel.stopRestTimer()
                    if workoutSet.completedApproach >= workoutSet.approach {
                        trainingScreen = .complete
                    } else if isCV {
                        trainingScreen = .cvProcess
                    } else {
                        trainingScreen = .handleProcess
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func timeWindow() -> some View {
        let data: [Double] = [0, 1, 2, 3, 4, 5,]
        GeometryReader { proxy in
            VStack {
                Text("Выберите время")
                    .headText()
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Picker("", selection: $selectedMinutesIndex) {
                    ForEach(0..<data.count, id: \.self) { time in
                        Text("\(time) мин")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.wheel)
                DefaultButton(label: "Сохранить") {
                    trainingViewModel.addRestTime(Int(data[selectedMinutesIndex] * 60))
                    showWindow = false
                }
                .frame(maxHeight: proxy.size.height * 0.2)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .mainBlock()
        }
        
    }
}
//
//#Preview {
//    TrainingRestView()
//}
