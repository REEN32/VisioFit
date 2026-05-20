import SwiftUI

struct RegisterSecondInputView: View {
    @EnvironmentObject var vm: RegisterViewModel
    @Environment(\.isFirstLaunch) var isFirstLaunch
    
    var isFormValid: Bool {
        !vm.height.isEmpty && !vm.weight.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text("Visio")
                            .headText(fontSize: 40, weight: .bold)
                        Text("Fit")
                            .orangeText(fontSize: 40)
                    }
                    .padding(.top, 30)
                    Spacer()
                    VStack(spacing: 00) {
                        VStack(alignment: .leading, spacing: 20) {
                            InputElement(name: "Рост", descriptionText: "Введите ваш рост", keyboardType: .numberPad, isNumberic: true, range: 1...250, textInput: $vm.height)
                            InputElement(name: "Вес", descriptionText: "Введите ваш вес", keyboardType: .decimalPad, isNumberic: true, range: 1...300, textInput: $vm.weight)
                        }
                    }
                    Spacer()
                    SecondaryButton(label: "Зарегестрироваться", selected: isFormValid) {
                        vm.registerUser()
                        isFirstLaunch.wrappedValue = false
                    }
                    .frame(maxHeight: proxy.size.height * 0.08)
                    .disabled(!isFormValid)
                    PageSelector(selectedPage: 2)
                        .frame(maxWidth: proxy.size.width * 0.18, maxHeight: proxy.size.height * 0.018)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RegisterSecondInputView()
}
