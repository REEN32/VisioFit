import Foundation
import SwiftUI


private enum ActiveParam: Identifiable {
    var id: Int { self.hashValue }
    case kkal
}

struct SettingsView: View {
    @FetchRequest(sortDescriptors: []) private var allWorkoutSets: FetchedResults<WorkoutSet>
    
    @ObservedObject var user: User
    
    @State private var toPushups: Bool = false
    @State private var toPlank: Bool = false
    @State private var toSquat: Bool = false
        
    var pushupWorkout: WorkoutSet? {
        allWorkoutSets.first { $0.trainingType == .pushup }
    }
    var plankWorkout: WorkoutSet? {
        allWorkoutSets.first { $0.trainingType == .plank }
    }
    var squatWorkout: WorkoutSet? {
        allWorkoutSets.first { $0.trainingType == .squat }
    }
    
    @State private var activeParam: ActiveParam?
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                ParametrRow(iconName: "birthday.cake.fill", name: "Каллории", value: String(user.kkalGoal), valueType: "ккал") {
                    self.activeParam = .kkal
                }
                    .frame(minHeight: 60)
                if let pushup = self.pushupWorkout {
                    ParametrRow(iconName: pushup.image ?? "square.fill", name: "\(pushup.name ?? "")", value: "", valueType: "") {
                        self.toPushups = true
                    }
                    .frame(minHeight: 60)
                }
                if let plank = self.plankWorkout {
                    ParametrRow(iconName: plank.image ?? "square.fill", name: "\(plank.name ?? "")", value: "", valueType: "") {
                        self.toPlank = true
                    }
                    .frame(minHeight: 60)
                }
                if let squat = self.squatWorkout {
                    ParametrRow(iconName: squat.image ?? "square.fill", name: "\(squat.name ?? "")", value: "", valueType: "") {
                        self.toSquat = true
                    }
                    .frame(minHeight: 60)
                }
                Spacer()
            }
            .padding(15)
            .sheet(item: $activeParam) { param in
                switch param {
                case .kkal:
                    CaloriesView(user: user)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("Параметры")
                        .headText()
                        .textCase(.uppercase)
                }
            }
            .navigationDestination(isPresented: $toPushups) {
                if let pushup = self.pushupWorkout {
                    WorkoutView(workout: pushup)
                }
            }
           
            .navigationDestination(isPresented: $toPlank) {
                if let plank = self.plankWorkout {
                    WorkoutView(workout: plank)
                }
            }
            .navigationDestination(isPresented: $toSquat) {
                if let squat = self.squatWorkout {
                    WorkoutView(workout: squat)
                }
            }
        }
    }
}
