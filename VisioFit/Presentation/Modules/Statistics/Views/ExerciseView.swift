import SwiftUI

struct ExerciseView: View {
    let exerciseName: String
    @State private var showBasicChart: Bool = true
    let workouts: Set<Workout>
    
    @StateObject var exercisesViewModel: ExerciseViewModel
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Group {
                            SecondaryButton(label: "Повторения", weight: .bold, selected: exercisesViewModel.chartType == .rep) {
                                exercisesViewModel.chartType = .rep
                            }
                            SecondaryButton(label: "Сессии", weight: .bold, selected: exercisesViewModel.chartType == .session) {
                                exercisesViewModel.chartType = .session
                            }
                            SecondaryButton(label: "Точность", weight: .bold, selected: exercisesViewModel.chartType == .accuracy) {
                                exercisesViewModel.chartType = .accuracy
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
                                SecondaryButton(label: "Нед", weight: .bold, selected: exercisesViewModel.timePeriod == .week) {
                                    exercisesViewModel.timePeriod = .week
                                }
                                SecondaryButton(label: "Мес", weight: .bold, selected: exercisesViewModel.timePeriod == .month) {
                                    exercisesViewModel.timePeriod = .month
                                }
                                SecondaryButton(label: "Год", weight: .bold, selected: exercisesViewModel.timePeriod == .year) {
                                    exercisesViewModel.timePeriod = .year
                                }
                                SecondaryButton(label: "Всё", weight: .bold, selected: exercisesViewModel.timePeriod == .allTime) {
                                    exercisesViewModel.timePeriod = .allTime
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
                VStack(spacing: 15) {
                    HStack {
                        Text("Последние сессии")
                            .blockLabel()
                        Spacer()
                    }
                    VStack(spacing: 15) {
                        ForEach(exercisesViewModel.getHistoryWorkouts(), id: \.id) { workout in
                            HistoryRow(date: workout.date?.workoutDate ?? "",
                                       desctiptionRepetitions: Int(workout.exerciseSet?.count ?? 0),
                                       time: workout.duration.workoutTime,
                                       percent: Int(workout.exerciseSet?.metricPoint?.quality ?? 0))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                Spacer()
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
        .onChange(of: workouts) { _, newWorkouts in
            exercisesViewModel.rawWorkouts = newWorkouts
        }
    }
}
