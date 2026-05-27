import SwiftUI

struct CaloriesView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var user: User
    
    @State var calories: Int
    
    init(user: User) {
        self.user = user
        self._calories = State(initialValue: Int(user.height))
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свою цель ккал")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $calories) {
                        ForEach(Array(stride(from: 50, through: 5000, by: 50)), id: \.self) {
                            Text("\($0)")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    user.kkalGoal = Int16(calories)
                    CoreDataManager.shared.save()
                    dismiss()
                }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
