import SwiftUI

struct SexView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var user: User
    
    @State var gender: String
    
    init(user: User) {
        self.user = user
        self._gender = State(initialValue: user.wrappedGender)
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свой пол")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $gender) {
                        Text("Мужской")
                            .tag("Мужской")
                            .headText(fontSize: 24, weight: .bold)
                        Text("Женский")
                            .tag("Женский")
                            .headText(fontSize: 24, weight: .bold)
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    user.gender = self.gender
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
//    SexView(gender: .constant("Женский"))
//}
