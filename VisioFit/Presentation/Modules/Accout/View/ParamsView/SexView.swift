import SwiftUI

struct SexView: View {
    @Binding var gender: String
    
    @Environment(\.dismiss) var dismiss
    
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
                
                DefaultButton(label: "Сохранить") { dismiss() }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    SexView(gender: .constant("Женский"))
}
