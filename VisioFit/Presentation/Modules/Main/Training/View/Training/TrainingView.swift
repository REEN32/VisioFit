import SwiftUI

struct TrainingView: View {
    @FetchRequest(sortDescriptors: []) private var users: FetchedResults<User>
    
    var body: some View {
//        if let user = users.first {
//            AccoutContentView(user: user)
//        } else {
//            VStack {
//                Text("Ошибка загрузки")
//                    .headText()
//            }
//        }
    }
    
    
}

struct TrainingContentView: View {
    @State private var showWindow: Bool = false
    @State private var changeScreen: Bool = false
    @State private var isCV: Bool = false
    
    @State private var trainingType: TrainingType = .pushup
    
    var body: some View {
        ZStack {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("СЕГОДНЯ:")
                                    .blockLabel()
                                HStack(spacing: 10) {
                                    DefaultIcon(iconName: "square", maxWidth: 50, maxHeight: 50)
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("План на день")
                                            .headText(fontSize: 20)
                                        Text("4 упр • 35 мин")
                                            .accentDescription(fontSize: 16)
                                    }
                                }
                            }
                            Spacer()
                            VStack(spacing: 0) {
                                Spacer()
                                CircleProgrssBar(value: 52, maxValue: 100, lineWidth: 10, fontSize: 24, maxWidth: 90, maxHeight: 90)
                            }
                            .frame(minHeight: 100)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .mainBlock()
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 2)
                            .clipShape(Capsule())
                            .background(Color.borderBlock)
                            .padding(.top, 20)
                        
                        VStack(spacing: 15) {
                            TrainigRow(name: "Отжимания", image: "0.square.fill", desctiptionCount: 3, isTime: false, percent: 52) {
                                self.trainingType = .pushup
                                showWindow = true
                            }
                            TrainigRow(name: "Приседания", image: "figure.cross.training", desctiptionCount: 3, isTime: false, percent: 67) {
                                self.trainingType = .даун
                                showWindow = true
                            }
                            TrainigRow(name: "Планка", image: "square", desctiptionCount: 3, isTime: true, percent: 100) {
                                self.trainingType = .pushup
                                showWindow = true
                            }
                        }
                        .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                }
                if showWindow {
                    VStack() {
                        selectWindow()
                            .frame(maxWidth: proxy.size.width / 1.4, maxHeight: proxy.size.height / 1.5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("Мои тренировки")
                    .headText()
                    .textCase(.uppercase)
            }
        }
        .fullScreenCover(isPresented: $changeScreen) {
            if isCV {
                TrainingRouter(trainingScreen: .cvProcess, trainingType: trainingType) {
                    changeScreen = false
                }
            } else {
                TrainingRouter(trainingScreen: .handleProcess, trainingType: trainingType) {
                    changeScreen = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectWindow() -> some View {
        GeometryReader { proxy in
            VStack {
                Text("Выберите режим")
                    .headText()
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Spacer()
                Text("💪")
                    .font(.system(size: 200))
                Spacer()
                VStack(spacing: 00) {
                    SecondaryButton(label: "Компьютерное зрение", weight: .bold, selected: true) {
                        showWindow = false
                        isCV = true
                        changeScreen = true
                    }
                    .frame(maxWidth: proxy.size.width * 0.9, maxHeight: proxy.size.height * 0.2)
                    Button {
                        showWindow = false
                        isCV = false
                        changeScreen = true
                    } label: {
                        Text("Стандартный")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: proxy.size.width / 1.5,maxHeight: proxy.size.height * 0.1)
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .mainBlock()
        }
    }
}



#Preview {
    TrainingView()
}
