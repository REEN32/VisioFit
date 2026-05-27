import SwiftUI

struct WorkoutSetRepsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var workout: WorkoutSet
    @State var reps: Int
    
    init(workout: WorkoutSet) {
        self.workout = workout
        self._reps = State(initialValue: Int(workout.requirementReps))
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите количество повторений")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $reps) {
                        ForEach(1...250, id: \.self) {
                            Text("\($0)")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    workout.requirementReps = Int16(reps)
                    CoreDataManager.shared.save()
                    dismiss()
                }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
