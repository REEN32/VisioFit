import Foundation
import SwiftUI

private enum ActiveParam: Identifiable {
    var id: Int { self.hashValue }
    case approach
    case reps
}

struct WorkoutView: View {
    
    @ObservedObject var workout: WorkoutSet
    
    @State private var activeParam: ActiveParam?
    
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                ParametrRow(iconName: workout.image ?? "square.fill", name: "Подходы", value: String(workout.approach), valueType: "\(workout.approach > 4 ? "подходов" : "подхода")") {
                    self.activeParam = .approach
                }
                .frame(minHeight: 60)
                ParametrRow(iconName: workout.image ?? "square.fill", name: "Повторения", value: String(workout.requirementReps), valueType: "\(workout.requirementReps > 4 ? "повторений" : "повторений")") {
                    self.activeParam = .reps
                }
                .frame(minHeight: 60)
                Spacer()
            }
            .padding(15)
            .sheet(item: $activeParam) { param in
                switch param {
                case .approach:
                    WorkoutSetApproachView(workout: self.workout)
                case .reps:
                    WorkoutSetRepsView(workout: self.workout)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("\(workout.name ?? "")")
                    .headText()
                    .textCase(.uppercase)
            }
        }
    }
}

