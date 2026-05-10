import SwiftUI

struct RegisterView : View {
    @EnvironmentObject var router: RegisterRouter
    
    @State private var showPayment: Bool = false
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("TRACK · MOVE · IMPROVE")
                            .accentDescription()
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("Visio")
                                .headText(fontSize: 40, weight: .bold)
                            Text("Fit")
                                .orangeText(fontSize: 40)
                        }
                        VStack(alignment: .center) {
                            Text("Компьютерное зрение анализирует вашу технику в реальном времени")
                                .accentDescription(fontSize: 16)
                                .multilineTextAlignment(.center)
                        }
                    }
                    Spacer()
                    Spacer()
                    VStack(spacing: 20) {
                        DefaultButton(label: "Купить подписку", fontSize: 30, weight: .bold) {
                            showPayment = true
                        }
                        .frame(maxHeight: proxy.size.height * 0.1)
                        Text("или")
                            .accentDescription(fontSize: 20)
                        DefaultButton(label: "Начать бесплатно") {
                            router.push(to: .firstInput)
                        }
                        .frame(maxHeight: proxy.size.height * 0.08)
                    }
                    
                    PageSelector(selectedPage: 0)
                        .frame(maxWidth: proxy.size.width * 0.18, maxHeight: proxy.size.height * 0.018)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                
                
                if showPayment {
                    VStack() {
                        PaymentView()
                            .frame(maxWidth: proxy.size.width / 1.4, maxHeight: proxy.size.height / 3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                }
            }
        }
    }
    
    @ViewBuilder
    private func PaymentView() -> some View {
        GeometryReader { proxy in
            VStack(spacing: 70) {
                Spacer()
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text("Всего")
                        .headText(fontSize: 30)
                    Text("$0")
                        .orangeText(fontSize: 30)
                }
                SecondaryButton(label: "Оплатить", fontSize: 20, weight: .bold, selected: true) {
                    showPayment = false
                    router.push(to: .firstInput)
                }
                .frame(maxHeight: proxy.size.height * 0.1)
                Spacer()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .mainBlock()
    }
}

#Preview {
    RegisterView()
}
