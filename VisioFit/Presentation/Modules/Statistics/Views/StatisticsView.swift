import SwiftUI

struct StatisticsView: View {
    @FetchRequest(sortDescriptors: []) private var users: FetchedResults<User>
    
    @StateObject private var statisticViewModel = StatisticViewModel()
    @State private var showBasicChart: Bool = true
    
    private var workouts: Set<Workout> {
        guard let user = users.first,
              let workoutSet = user.workout as? Set<Workout> else { return [] }
        return workoutSet
    }
    
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
                        SecondaryButton(label: "Нед", weight: .bold, selected: statisticViewModel.timePeriod == .week) {
                            statisticViewModel.timePeriod = .week
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Мес", weight: .bold, selected: statisticViewModel.timePeriod == .month) {
                            statisticViewModel.timePeriod = .month
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Год", weight: .bold, selected: statisticViewModel.timePeriod == .year) {
                            statisticViewModel.timePeriod = .year
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                        SecondaryButton(label: "Всё", weight: .bold, selected: statisticViewModel.timePeriod == .allTime) {
                            statisticViewModel.timePeriod = .allTime
                        }
                        .frame(maxWidth: 100, maxHeight: 40)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxHeight: 35)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(statisticViewModel.averageAccuracyText)%")
                                    .orangeText(fontSize: 36)
                                Text("Средняя точность")
                                    .accentDescription(fontSize: 16)
                                
                                Spacer()
                                
                                Text("\(statisticViewModel.accuracyChange)% от \(statisticViewModel.timeAverageString)")
                                    .statisticsText(isPositive: true, fontSize: 15)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .mainBlock()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(statisticViewModel.repeatCount)
                                    .headText(fontSize: 36)
                                Text("Повторений")
                                    .accentDescription(fontSize: 16)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(statisticViewModel.repeatChange) от \(statisticViewModel.timeAverageString)")
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
                                Text("Точность по \(statisticViewModel.timePeriodString)")
                                    .accentDescription(fontSize: 20, weight: .bold)
                                Spacer()
                                Text("\(statisticViewModel.accuracyDiff)%")
                                    .orangeText(fontSize: 26)
                            }
                            Button {
                                showBasicChart.toggle()
                            } label: {
                                if showBasicChart  {
                                    BasicChart(data: statisticViewModel.chartData)
                                } else {
                                    AccuracyChart(data: statisticViewModel.chartData)
                                }
                            }
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
                                NavigationLink(destination: {
                                    let vm = ExerciseViewModel(trainingType: .pushup)
                                    vm.rawWorkouts = self.workouts
                                    return ExerciseView(exerciseName: "Отжимания", workouts: self.workouts, exercisesViewModel: vm)
                                }()) {
                                    ExerciseRow(name: "Отжимания",
                                                desctiptionRepetitions: statisticViewModel.pushupsReps,
                                                descriptionTraining: statisticViewModel.pushupsSession,
                                                percent: statisticViewModel.pushupsAccuracy)
                                }
                                NavigationLink(destination: {
                                    let vm = ExerciseViewModel(trainingType: .squat)
                                    vm.rawWorkouts = self.workouts
                                    return ExerciseView(exerciseName: "Приседания", workouts: self.workouts, exercisesViewModel: vm)
                                }()) {
                                    ExerciseRow(name: "Приседания",
                                                desctiptionRepetitions: statisticViewModel.squatReps,
                                                descriptionTraining: statisticViewModel.squatSession,
                                                percent: statisticViewModel.squatAccuracy)
                                }
                                NavigationLink(destination: {
                                    let vm = ExerciseViewModel(trainingType: .plank)
                                    vm.rawWorkouts = self.workouts
                                    return ExerciseView(exerciseName: "Планка", workouts: self.workouts, exercisesViewModel: vm)
                                }()) {
                                    ExerciseRow(name: "Планка",
                                                desctiptionRepetitions: statisticViewModel.plankReps,
                                                descriptionTraining: statisticViewModel.plankSession,
                                                percent: statisticViewModel.plankAccuracy)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                        
                        Color.clear
                            .frame(height: 80)
                    }
                }
            }
        }
        .onAppear {
            statisticViewModel.rawWorkouts = self.workouts
        }
        .onChange(of: workouts) { _, newWorkouts in
            statisticViewModel.rawWorkouts = newWorkouts
        }
    }
}
