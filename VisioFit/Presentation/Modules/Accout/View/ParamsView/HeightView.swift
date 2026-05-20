import SwiftUI

struct HeightView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var user: User
    
    @State var height: Int
    
    init(user: User) {
        self.user = user
        self._height = State(initialValue: Int(user.height))
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свой рост")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $height) {
                        ForEach(1...250, id: \.self) {
                            Text("\($0)")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaultButton(label: "Сохранить") {
                    user.height = Int16(height)
                    CoreDataManager.shared.save()
                    dismiss()
                }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
