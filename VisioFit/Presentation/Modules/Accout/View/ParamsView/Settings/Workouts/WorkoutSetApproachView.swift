import SwiftUI

struct WorkoutSetApproachView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var workout: WorkoutSet
    @State var approach: Int
    
    init(workout: WorkoutSet) {
        self.workout = workout
        self._approach = State(initialValue: Int(workout.approach))
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите количество подходов")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $approach) {
                        ForEach(1...250, id: \.self) {
                            Text("\($0)")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    workout.approach = Int16(approach)
                    CoreDataManager.shared.save()
                    dismiss()
                }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
