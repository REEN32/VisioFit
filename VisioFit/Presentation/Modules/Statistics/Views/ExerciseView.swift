import SwiftUI

enum Stats {
    case count
    case session
    case quality
}

struct ExerciseView: View {
    let exerciseName: String
    
    @State private var selectedStat: Stats = .count
    @State private var timePeriod: TimePeriod = .week
    @State private var showBasicChart: Bool = true
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Group {
                            SecondaryButton(label: "Повторения", weight: .bold, selected: selectedStat == .count) {
                                selectedStat = .count
                            }
                            SecondaryButton(label: "Сессии", weight: .bold, selected: selectedStat == .session) {
                                selectedStat = .session
                            }
                            SecondaryButton(label: "Точность", weight: .bold, selected: selectedStat == .quality) {
                                selectedStat = .quality
                            }
                        }
                        .frame(minWidth: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                }
                .frame(height: 40)
                VStack(spacing: 25) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            Group {
                                SecondaryButton(label: "Нед", weight: .bold, selected: timePeriod == .week) {
                                    timePeriod = .week
                                }
                                SecondaryButton(label: "Мес", weight: .bold, selected: timePeriod == .month) {
                                    timePeriod = .month
                                }
                                SecondaryButton(label: "Год", weight: .bold, selected: timePeriod == .year) {
                                    timePeriod = .year
                                }
                                SecondaryButton(label: "Всё", weight: .bold, selected: timePeriod == .allTime) {
                                    timePeriod = .allTime
                                }
                            }
                            .frame(minWidth: 100)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                    }
                    .frame(height: 40)
                    .padding(.top, 15)
                    Button {
                        showBasicChart.toggle()
                    } label: {
                        if showBasicChart {
                            BasicChart(data: [1, 2, 3, 4, 5])
                        } else {
                            AccuracyChart(data: [1, 2, 3, 4, 5])
                        }
                    }
                    .padding(15)
                }
                .mainBlock()
                .padding(.horizontal, 20)
                .padding(.top, 15)
                Spacer()
                VStack(spacing: 15) {
                    HStack {
                        Text("Последние сессии")
                            .blockLabel()
                        Spacer()
                    }
                    VStack(spacing: 15) {
                        HistoryRow(date: "27 ноя, Пн • 14:00", desctiptionRepetitions: 53, time: "4:32", percent: 84)
                        HistoryRow(date: "27 ноя, Пн • 14:00", desctiptionRepetitions: 53, time: "4:32", percent: 84)
                        HistoryRow(date: "27 ноя, Пн • 14:00", desctiptionRepetitions: 53, time: "4:32", percent: 84)
                        HistoryRow(date: "27 ноя, Пн • 14:00", desctiptionRepetitions: 53, time: "4:32", percent: 84)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                
                Color.clear
                    .frame(height: 80)
            }
            .padding(.top, 15)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .title) {
                Text(exerciseName)
                    .headText()
                    .textCase(.uppercase)
            }
        }
    }
}

#Preview {
    ExerciseView(exerciseName: "Отжимания")
}
