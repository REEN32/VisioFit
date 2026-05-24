import SwiftUI
import CoreData

struct TrainingCompleteView: View {
    var onDismiss: () -> Void
    
    @EnvironmentObject private var coreDataManager: CoreDataManager
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    @Environment(\.managedObjectContext) private var context
    
    private var workoutSet: WorkoutSet
    
    init(workoutSet: WorkoutSet, onDismiss: @escaping () -> Void) {
        self.workoutSet = workoutSet
        self.onDismiss = onDismiss
    }
    
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
                                    Text("\(trainingViewModel.perfectReps)")
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
                                Text("\(trainingViewModel.perfectReps)")
                                    .statisticsText(isPositive: true, fontSize: 26)
                                Text("идеальных")
                                    .accentDescription(fontSize: 14)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .greenTintBlock()
                            VStack {
                                Text("\(trainingViewModel.goodReps)")
                                    .orangeText(fontSize: 26)
                                Text("хороших")
                                    .accentDescription(fontSize: 14)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .orangeTintBlock()
                            VStack {
                                Text("\(trainingViewModel.badReps)")
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
        }
        .onAppear {
            DispatchQueue.global(qos: .default).async {
                coreDataManager.addEntity(Workout.self) { workout in
                    let metric = MetricPoint(context: context)
                    metric.quality = Double(trainingViewModel.averageAccuracy)
                    
                    let exerciseSet = ExerciseSet(context: context)
                    exerciseSet.approach = workoutSet.completedApproach
                    // Дописать
                    exerciseSet.name = workoutSet.name
                    exerciseSet.count = Int16(trainingViewModel.totalReps)
                    exerciseSet.metricPoint = metric
                    
                    workout.id = UUID()
                    workout.date = Date()
                    workout.duration = Int64(trainingViewModel.trainingTime)
                    workout.totalCalories = 100 // Заменить на подсчёт каллорий
                    workout.exerciseSet = exerciseSet
                }
//                coreDataManager.addWorkout { user in
//                    // Протестить работоспособность (скорее всего не работает в TrainingView)
//                    let metric = MetricPoint(context: context)
//                    metric.quality = Double(trainingViewModel.averageAccuracy)
//
//                    let exerciseSet = ExerciseSet(context: context)
//                    exerciseSet.approach = workoutSet.completedApproach
//                    // Дописать
//                    exerciseSet.name = workoutSet.name
//                    exerciseSet.count = Int16(trainingViewModel.totalReps)
//                    exerciseSet.metricPoint = metric
//                    
//                    let workout = Workout()
//                    workout.id = UUID()
//                    workout.date = Date()
//                    workout.duration = Int64(trainingViewModel.trainingTime)
//                    workout.totalCalories = 100 // Заменить на подсчёт каллорий
//                    workout.exerciseSet = exerciseSet
//                    
//                    user.addToWorkout(workout)
//                }
            }
        }
        .onDisappear {
            trainingViewModel.cleanApproach(workoutSet: workoutSet, context: context)
        }
    }
}
