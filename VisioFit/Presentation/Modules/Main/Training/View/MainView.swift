import SwiftUI

fileprivate enum ChartType: String {
    case kkal = "килокалории"
    case steps = "шаги"
    case range = "киллометры"
    case time = "время тренировок"
}

struct MainView: View {
    @State private var chartType: ChartType = .kkal
    @State private var data: [Double] = []
    private var chartTitle: String {
        "неделя (\(chartType.rawValue))"
    }
    
    @State private var toTraining: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color.baseBg
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Пятница, 10 апреля")
                                    .accentDescription()
                                Text("Привет, Герман!")
                                    .headText()
                            }
                            Spacer()
                        }
                        
                        Button {
                            chartType = .kkal
                            CoreDataManager.shared.deleteUser() // !!!!!!!!!
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Сожжено сегодня")
                                        .blockLabel()
                                    Spacer()
                                }
                                Text("634")
                                    .orangeText(fontSize: 46)
                                Text("ккал из 1 000")
                                    .accentDescription()
                                DefaultProgressBar(actualValue: 634, maxValue: 1000)
                                    .frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10)
                                    .padding(.vertical, 5)
                                Text("63% цели")
                                    .orangeText()
                            }
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                Circle()
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .offset(x: 120, y: -70)
                                Circle()
                                    .frame(maxWidth: 150, maxHeight: 150)
                                    .offset(x: -30, y: 100)
                            }
                                .foregroundStyle(Color.orangeTint)
                        )
                        .mainBlock()
                        
                        
                        HStack(spacing: 15) {
                            Group {
                                statBlock(iconName: "shoe", value: 8360, description: "шагов") {
                                    chartType = .steps
                                }
                                statBlock(iconName: "figure.step.training", value: 5.3, description: "км") {
                                    CoreDataManager.shared.getWorkouts()
                                    chartType = .range
                                }
                                statBlock(iconName: "clock", value: 45, description: "мин трен") {
                                    CoreDataManager.shared.getWorkoutsAccuracy()
                                    chartType = .time
                                }
                            }
                            .frame(minWidth: 30, minHeight: 115)
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .mainBlock()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 15)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(chartTitle)
                                    .blockLabel()
                                Spacer()
                            }
                            
                            BasicChart(data: data)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 15)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Мои тренировки")
                                    .blockLabel()
                                Spacer()
                            }
                            SecondaryButton(label: "К тренировкам", weight: .bold, selected: true) {
                                toTraining = true
                            }
                            .frame(minHeight: 50, maxHeight: 100)
                            .navigationDestination(isPresented: $toTraining) {
                                TrainingView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 15)
                        
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    
                    Color.clear
                        .frame(height: 80)
                }
                .onAppear {
                    setData()
                }
                .onChange(of: chartType) {
                    setData()
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func statBlock(iconName: String, value: Double, description: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    DefaultIcon(iconName: iconName, maxWidth: 60, maxHeight: 60)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(value.formatted())")
                            .headText(fontSize: 20)
                        Text(description)
                            .accentDescription(fontSize: 14)
                    }
                }
                Spacer()
            }
        }
    }
    
    private func setData() {
        switch chartType {
        case .kkal:
            data = [1204, 3021, 2222, 2000, 1234, 3321, 1211]
        case .steps:
            data = [8000, 11002, 15321, 8340, 12332, 100, 15000]
        case .range:
            data = [7.5, 10.6, 14.23, 7, 10.7, 0.5, 15]
        case .time:
            data = [47, 60, 12, 32, 63, 23, 52]

        }
    }
}

#Preview {
    MainView()
}
