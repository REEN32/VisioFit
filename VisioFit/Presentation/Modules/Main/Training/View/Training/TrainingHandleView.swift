import SwiftUI

struct TrainingHandleView: View {
    @State private var countString: String = "0"
    
    @Binding var trainingScreen: TrainingScreen
    @EnvironmentObject private var trainingViewModel: TrainingViewModel
    @Environment(\.managedObjectContext) private var context
    
    private var workoutSet: WorkoutSet
    
    init(trainingScreen: Binding<TrainingScreen>, workoutSet: WorkoutSet) {
        self._trainingScreen = trainingScreen
        self.workoutSet = workoutSet
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .lastTextBaseline) {
                            Text(workoutSet.name ?? "Неизвестно")
                                .headText(fontSize: 26)
                            Spacer()
                            Text("\(workoutSet.completedApproach) подход")
                                .headText(fontSize: 18)
                        }
                        HStack(alignment: .lastTextBaseline) {
                            Text(countString)
                                .headText(fontSize: 60)
                            Text("повторений")
                                .headText(fontSize: 22, weight: .medium)
                        }
                        RepeatCountLines(count: trainingViewModel.reps, target: 12)
                        // тут ещё сделать target на динамичекий !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .background(Color.accentOrange)
                    
                    VStack(alignment: .center, spacing: 30) {
                        Button {
                            trainingViewModel.reps += 1
                            countString = String(trainingViewModel.reps)
                        } label: {
                            Image(systemName: "arrowshape.up.fill")
                                .padding(20)
                                .background(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                )
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                        
                        
                        // Сделать TextField который нельзя выделять
//                        TextField("", text: $countString)
//                            .headText(fontSize: 60)
//                            .multilineTextAlignment(.center)
//                            .keyboardType(.numberPad)
                        Text(countString)
                            .headText(fontSize: 60)
                            
                        Button {
                            if trainingViewModel.reps > 0 {
                                trainingViewModel.reps -= 1
                                countString = String(trainingViewModel.reps)
                            }
                        } label: {
                            Image(systemName: "arrowshape.down.fill")
                                .padding(20)
                                .background(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                )
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    HStack {
                        DefaultIcon(iconName: "info.circle", maxWidth: 40, maxHeight: 40)
                        Text("TEST TEST TEST")
                            .accentDescription(fontSize: 16)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .orangeTintBlock()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    
                    VStack(spacing: 15) {
                        DefaultButton(label: "Закончить подход") {
                            trainingScreen = .rest
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                    .frame(maxHeight: proxy.size.height * 0.12)
                }
                
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            trainingViewModel.startTimer()
            trainingViewModel.addApproach(workoutSet: workoutSet, context: context)
        }
        .onDisappear {
            trainingViewModel.updateReps()
            trainingViewModel.stopTimer()
        }
    }
}

//#Preview {
//    TrainingHandleView()
//}
