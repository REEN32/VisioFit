import SwiftUI

struct StatisticsView: View {
    @State private var timePeriod: TimePeriod = .week
    @State private var showBasicChart: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color.baseBg
                    .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .center) {
                        Text("Статистика")
                            .headText()
                    }
                    .frame(maxWidth: .infinity)
                    HStack(spacing: 15) {
                        SecondaryButton(label: "Нед", weight: .bold, selected: timePeriod == .week) {
                            timePeriod = .week
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Мес", weight: .bold, selected: timePeriod == .month) {
                            timePeriod = .month
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Год", weight: .bold, selected: timePeriod == .year) {
                            timePeriod = .year
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Всё", weight: .bold, selected: timePeriod == .allTime) {
                            timePeriod = .allTime
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxHeight: 35)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("87%")
                                    .orangeText(fontSize: 36)
                                Text("Средняя точность")
                                    .accentDescription(fontSize: 16)
                                
                                Spacer()
                                
                                Text("+4% от прошлой недели")
                                    .statisticsText(isPositive: true, fontSize: 15)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .mainBlock()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("264")
                                    .headText(fontSize: 36)
                                Text("Повторений")
                                    .accentDescription(fontSize: 16)
                                
                                Spacer(minLength: 0)
                                
                                Text("+46 от прошлой недели")
                                    .statisticsText(isPositive: true, fontSize: 15)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .mainBlock()
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                        
                        VStack {
                            HStack {
                                Text("Точность по сессиям")
                                    .accentDescription(fontSize: 20, weight: .bold)
                                Spacer()
                                Text("+12%")
                                    .orangeText(fontSize: 26)
                            }
                            Button {
                                showBasicChart.toggle()
                            } label: {
                                if showBasicChart  {
                                    BasicChart(data: [10, 20, 50, 20, 40, 60, 30])
                                    // при нажатии месяц будет по неделям, год - по месяцам, всё - по годам
                                } else {
                                    AccuracyChart(data: [10, 20, 50, 20, 40, 60, 30])
                                }
                            }
                            //                            .frame(height: 140)
                            
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .mainBlock()
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                        
                        VStack {
                            HStack {
                                Text("По упражнениям")
                                    .blockLabel()
                                Spacer()
                            }
                            
                            VStack(spacing: 15) {
                                NavigationLink(destination: ExerciseView(exerciseName: "Отжимания")) {
                                    ExerciseRow(name: "Отжимания",
                                                desctiptionRepetitions: 142,
                                                descriptionTraining: 8,
                                                percent: 84)
                                }
                                NavigationLink(destination: ExerciseView(exerciseName: "Приседания")) {
                                    ExerciseRow(name: "Приседания",
                                                desctiptionRepetitions: 235,
                                                descriptionTraining: 12,
                                                percent: 68)
                                }
                                NavigationLink(destination: ExerciseView(exerciseName: "Планка")) {
                                    ExerciseRow(name: "Планка",
                                                desctiptionRepetitions: 142,
                                                isTimeCounting: true,
                                                descriptionTraining: 8,
                                                percent: 90)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                        
                        Color.clear
                            .frame(height: 80)
                    }
                }
                //            .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    StatisticsView()
}
