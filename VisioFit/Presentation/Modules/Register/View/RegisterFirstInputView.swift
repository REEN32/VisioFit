import SwiftUI

struct RegisterFirstInputView: View {
    @EnvironmentObject var router: RegisterRouter
    @EnvironmentObject var vm: RegisterViewModel
    
    @State private var selectedButton: Int = 0
    
    private var isFormValid: Bool {
        !vm.name.isEmpty && !vm.age.isEmpty && !vm.gender.isEmpty
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
                            InputElement(name: "имя", descriptionText: "Введите ваше имя", textInput: $vm.name)
                            InputElement(name: "Возраст", descriptionText: "Введите ваш возраст", keyboardType: .decimalPad, isNumberic: true, range: 1...99, textInput: $vm.age)
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Пол")
                                    .accentDescription(fontSize: 20, weight: .bold)
                                    .textCase(.uppercase)
                                HStack(spacing: 10) {
                                    SecondaryButton(label: "Мужской", selected: selectedButton == 1) {
                                        selectedButton = 1
                                        vm.gender = "Мужской"
                                    }
                                    SecondaryButton(label: "Женский", selected: selectedButton == 2) {
                                        selectedButton = 2
                                        vm.gender = "Женский"
                                    }
                                }
                            }
                            .frame(maxHeight: 80)
                        }
                    }
                    Spacer()
                    SecondaryButton(label: "Далее", selected: isFormValid) {
                        router.push(to: .secondInput)
                    }
                    .frame(maxHeight: proxy.size.height * 0.08)
                    .disabled(!isFormValid)
                    PageSelector(selectedPage: 1)
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
    RegisterFirstInputView()
}
