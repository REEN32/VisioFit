import SwiftUI

struct RegisterFirstInputView: View {
    @State private var selectedButton: Int = 0
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text("Visio")
                        .headText(fontSize: 40, weight: .bold)
                    Text("Fit")
                        .orangeText(fontSize: 40)
                }
                
                
                VStack(spacing: 00) {
                    VStack(alignment: .leading, spacing: 20) {
                        InputElement(name: "имя", descriptionText: "Введите ваше имя")
                        InputElement(name: "Возраст", descriptionText: "Введите ваше имя", keyboardType: .decimalPad)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Пол")
                                .accentDescription(fontSize: 20, weight: .bold)
                                .textCase(.uppercase)
                            HStack(spacing: 10) {
                                SecondaryButton(label: "Мужской", selected: selectedButton == 1) {
                                    selectedButton = 1
                                }
                                SecondaryButton(label: "Женский", selected: selectedButton == 2) {
                                    selectedButton = 2
                                }
                            }
                        }
                        .frame(maxHeight: 80)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    RegisterFirstInputView()
}
