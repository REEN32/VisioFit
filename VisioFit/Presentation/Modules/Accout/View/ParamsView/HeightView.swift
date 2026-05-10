import SwiftUI

struct HeightView: View {
    @Binding var height: Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свой рост")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $height) {
                        ForEach(80...220, id: \.self) {
                            Text("\($0)")
                                .headText(fontSize: 24, weight: .bold)
                        }
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
    HeightView(height: .constant(100))
}
