import SwiftUI

struct WeightView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var user: User
    
    @State var weight: Double
    
    private var range: [Double] = Array(stride(from: 1, through: 300, by: 0.5))
    
    init(user: User) {
        self.user = user
        self._weight = State(initialValue: user.weight)
    }

    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свой вес")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $weight) {
                        ForEach(range, id: \.self) {
                            Text("\($0.formatted())")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    user.weight = self.weight
                    CoreDataManager.shared.save()
                    dismiss()
                }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
//
//#Preview {
//    WeightView(weight: .constant(70))
//}
