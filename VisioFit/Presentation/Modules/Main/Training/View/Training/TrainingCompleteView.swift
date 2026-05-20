import SwiftUI

struct TrainingCompleteView: View {
    var onDismiss: () -> Void
    
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    
        
    // Во время экрана завершения всё равно анализируются и изменяются данные
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("+180 XP получено")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .headText(fontSize: 18)
                            .background {
                                Color.warmOrange.opacity(0.6)
                            }
                            .clipShape(Capsule())
                        Text("\(trainingViewModel.averageAccuracy)%")
                            .headText(fontSize: 56)
                        Text("Средняя точность подхода")
                            .headText(fontSize: 16, weight: .medium)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentOrange)
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Group {
                                VStack {
                                    Text("\(trainingViewModel.totalReps)")
                                        .orangeText(fontSize: 26)
                                    Text("повторений")
                                        .accentDescription(fontSize: 14)
                                }
                                VStack {
                                    Text("12")
                                        .statisticsText(isPositive: true, fontSize: 26)
                                    Text("идеальных")
                                        .accentDescription(fontSize: 14)
                                }
                                VStack {
                                    Text(trainingViewModel.timeString)
                                        .headText(fontSize: 26, weight: .bold)
                                    Text("мин")
                                        .accentDescription(fontSize: 14)
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .mainBlock()
                        }
                        
                        VStack() {
                            HStack {
                                Text("качество по повторениям")
                                    .blockLabel()
                                Spacer()
                            }
                            AccuracyChart(data: trainingViewModel.accuracyArray)
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .mainBlock()
                        
                        HStack(spacing: 15) {
                            VStack {
                                Text("7")
                                    .statisticsText(isPositive: true, fontSize: 26)
                                Text("идеальных")
                                    .accentDescription(fontSize: 14)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .greenTintBlock()
                            VStack {
                                Text("10")
                                    .orangeText(fontSize: 26)
                                Text("хороших")
                                    .accentDescription(fontSize: 14)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .orangeTintBlock()
                            VStack {
                                Text("5")
                                    .statisticsText(isPositive: false, fontSize: 26)
                                Text("плохих")
                                    .accentDescription(fontSize: 14)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .redTintBlock()
                        }
                        Spacer()
                        SecondaryButton(label: "На главную", selected: true) {
                            onDismiss()
                        }
                        .frame(maxHeight: proxy.size.height * 0.1)
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity)
            }
        }.onAppear()
    }
}

//#Preview {
//    TrainingCompleteView()
//}
