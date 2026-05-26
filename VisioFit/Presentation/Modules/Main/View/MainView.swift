import SwiftUI

struct MainView: View {
    @FetchRequest(sortDescriptors: []) private var users: FetchedResults<User>
    
    @StateObject private var mainViewModel: MainViewModel = MainViewModel()
    @StateObject private var healthViewModel: HealthViewModel = HealthViewModel()
    
    private var workouts: Set<Workout> {
        guard let user = users.first,
              let workoutSet = user.workout as? Set<Workout> else { return [] }
        return workoutSet
    }
    
    var body: some View {
        if let user = users.first {
            MainContentView(user: user, mainViewModel: mainViewModel, healthViewModel: healthViewModel)
                .onAppear {
                    mainViewModel.rawWorkouts = self.workouts
                    mainViewModel.steps = self.healthViewModel.stepsHistory
                    mainViewModel.distance = self.healthViewModel.distanceHistory
                    mainViewModel.calories = self.healthViewModel.caloriesHistory
                }
                .onChange(of: workouts) { _, newWorkouts in
                    mainViewModel.rawWorkouts = newWorkouts
                }
                .onChange(of: healthViewModel.stepsHistory) { _, newSteps in
                    mainViewModel.steps = newSteps
                }
                .onChange(of: healthViewModel.distanceHistory) { _, newDistance in
                    mainViewModel.distance = newDistance
                }
                .onChange(of: healthViewModel.caloriesHistory) { _, newCalories in
                    mainViewModel.calories = newCalories
                }
        } else {
            VStack {
                Text("Ошибка загрузки")
                    .headText()
            }
        }
    }
}

struct MainContentView: View {
    
    @ObservedObject var user: User
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var healthViewModel: HealthViewModel
    
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
                                Text("\(Date().todayDate)")
                                    .accentDescription()
                                Text("Привет, \(user.name ?? "")!")
                                    .headText()
                            }
                            Spacer()
                        }
                        
                        Button {
                            mainViewModel.chartType = .kkal
//                            CoreDataManager.shared.deleteUser() // !!!!!!!!!
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Сожжено сегодня")
                                        .blockLabel()
                                    Spacer()
                                }
                                Text("\(healthViewModel.calories.formatted())")
                                    .orangeText(fontSize: 46)
                                Text("ккал из \(user.kkalGoal)")
                                    .accentDescription()
                                DefaultProgressBar(actualValue: mainViewModel.calculatePercentCallories(actualCal: healthViewModel.calories, for: user), maxValue: Double(user.kkalGoal))
                                    .frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10)
                                    .padding(.vertical, 5)
                                Text("\(mainViewModel.calculatePercentCallories(actualCal: healthViewModel.calories, for: user).formatted())% цели")
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
                                statBlock(iconName: "shoe", value: healthViewModel.steps, description: "шагов") {
                                    mainViewModel.chartType = .steps
                                }
                                statBlock(iconName: "figure.step.training", value: healthViewModel.distance, description: "км") {
//                                    CoreDataManager.shared.getWorkouts()
                                    mainViewModel.chartType = .range
                                }
                                statBlock(iconName: "clock", value: mainViewModel.todayWorkoutsDuration, description: "сек трен") {
//                                    CoreDataManager.shared.getWorkoutsAccuracy()
                                    mainViewModel.chartType = .time
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
                                Text(mainViewModel.chartTitle)
                                    .blockLabel()
                                Spacer()
                            }
                            
                            BasicChart(data: mainViewModel.chartData)
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
            }
        }
        .onAppear {
            healthViewModel.authorizeAndLoad()
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
}
