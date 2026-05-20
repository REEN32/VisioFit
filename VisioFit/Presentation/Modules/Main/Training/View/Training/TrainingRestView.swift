import SwiftUI

struct TrainingRestView: View {
    @State private var showWindow: Bool = false
    @State private var selectedMinutesIndex: Int = 0
    
    @Binding var trainingScreen: TrainingScreen
    
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Упражнение 2/5")
                                    .headText(fontSize: 24, weight: .bold)
                                Text("Планка")
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
                            trainingScreen = .complete
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
            trainingViewModel.startRestTimer()
        }
        .onChange(of: trainingViewModel.restTime) { oldValue, newValue in
            if newValue == 0 {
                DispatchQueue.main.async {
                    trainingViewModel.stopRestTimer()
                    trainingScreen = .complete
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
