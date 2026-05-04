import SwiftUI

struct TrainingRestView: View {
    @State private var showWindow: Bool = false
    
    @Binding var trainingScreen: TrainingScreen
    
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
                                Text("00:18:42")
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
                        
                        Text("03:00")
                            .headText(fontSize: 80)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        DefaulButton(label: "Добавить вермя") {
                            showWindow = true
                        }
                        DefaulButton(label: "Следующий подход") {
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
    }
    
    @ViewBuilder
    private func timeWindow() -> some View {
        let data: [Double] = [1, 2, 3, 4, 5,]
        GeometryReader { proxy in
            VStack {
                Text("Выберите время")
                    .headText()
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Picker("", selection: .constant(15)) {
                    ForEach(0..<data.count, id: \.self) { time in
                        Text("\(time) мин")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.wheel)
                DefaulButton(label: "Сохранить") {
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
