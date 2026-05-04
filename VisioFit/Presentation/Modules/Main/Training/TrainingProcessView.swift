import SwiftUI

struct TrainingProcessView: View {
    @Binding var trainingScreen: TrainingScreen
    
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
                            Text("12")
                                .headText(fontSize: 60)
                            Text("повторений")
                                .headText(fontSize: 22, weight: .medium)
                        }
                        RepeatCountLines(count: 9, target: 12)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .background(Color.accentOrange)
                    
                    VStack {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height * 0.6)
                    .background(Color.black)
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
                            Text("\(87)% точности")
                                .accuracyText(value: 87)
                            AccuracyBar(percent: 87)
                                .frame(height: 10)
                        }
                        .padding(15)
                        .mainBlock()
                        
                        DefaulButton(label: "Закончить подход") {
                            trainingScreen = .rest
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                }
                
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    TrainingProcessView(trainingScreen: .constant(.cvProcess))
}
