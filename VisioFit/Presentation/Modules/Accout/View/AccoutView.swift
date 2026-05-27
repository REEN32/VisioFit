import SwiftUI
import CoreData

struct AccoutView: View {
    @FetchRequest(sortDescriptors: []) private var users: FetchedResults<User>
    
    var body: some View {
        if let user = users.first {
            AccoutContentView(user: user)
        } else {
            VStack {
                Text("Ошибка загрузки")
                    .headText()
            }
        }
    }
}

private enum ActiveParam: Identifiable {
    var id: Int { self.hashValue }
    case height
    case width
    case gender
}

struct AccoutContentView: View {
    @ObservedObject var user: User
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var activeParam: ActiveParam?
    @State private var toSettings: Bool = false
    
    @StateObject var accountViewModel: AccountViewModel
    
    init(user: User) {
        self.user = user
        self._accountViewModel = StateObject(wrappedValue: AccountViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.baseBg
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        AccoutIcon()
                            .padding(20)
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(user.formattedName)
                                    .headText()
                                HStack {
                                    Text("Ур. \(user.level)")
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 15)
                                        .orangeText(fontSize: 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .foregroundStyle(Color.accentOrange.opacity(0.3))
                                        )
                                    Text(user.sportTitle)
                                        .accentDescription(fontSize: 20)
                                }
                            }
                            NavigationLink {
                                LevelView()
                            } label: {
                                VStack(spacing: 4) {
                                    HStack {
                                        Text(user.formattedXP)
                                            .accentDescription(fontSize: 15)
                                        Spacer()
                                        Text("\(user.xpPercent)%")
                                            .orangeText(fontSize: 15)
                                    }
                                    DefaultProgressBar(actualValue: Double(user.xp), maxValue: Double(user.nextXp))
                                        .frame(maxWidth: .infinity, maxHeight: 12)
                                }
                            }
                            .padding(.trailing, 10)

                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.surfaceBg)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack(spacing: 20) {
                                Group {
                                    VStack {
                                        Text("\(user.workout?.count ?? 0)")
                                            .orangeText(fontSize: 32)
                                        Text("Тренировок")
                                            .accentDescription(fontSize: 14)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack {
                                        if let accuracy = accountViewModel.averageAccuracy {
                                            Text("\(accuracy)%")
                                                .orangeText(fontSize: 32)
                                        } else {
                                            Text("—%")
                                                .orangeText(fontSize: 32)
                                        }
                                        Text("Точность")
                                            .accentDescription(fontSize: 14)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(10)
                                .mainBlock()
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            
                            
                            HStack {
                                Group {
                                    VStack {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 36, weight: .heavy))
                                            .foregroundStyle(accountViewModel.isStreakActiveToday ? Color.accentOrange : Color.accentDescription)
                                    }
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color.orangeTint)
                                    )
                                    VStack {
                                        Text("\(user.streak)")
                                            .orangeText(fontSize: 32)
                                        Text("Дней подряд")
                                            .accentDescription(fontSize: 14)
                                    }
                                    VStack {
                                        Text("\(user.maxStreak)")
                                            .font(.system(size: 32, weight: .bold))
                                            .descriptionStyle()
                                        Text("Лучшая серия")
                                            .accentDescription(fontSize: 14)
                                    }
                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                            }
                            .mainBlock()
                            .padding(.horizontal, 15)
                        }
                        .padding(.bottom, 15)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Парметры")
                                    .blockLabel()
                                Spacer()
                            }
                            ParametrRow(iconName: "arrow.up", name: "Рост", value: String(user.height), valueType: "см") {
                                activeParam = .height
                            }
                                .frame(minHeight: 60)
                            ParametrRow(iconName: "scalemass.fill", name: "Вес", value: String(user.weight), valueType: "кг") {
                                activeParam = .width
                            }
                                .frame(minHeight: 60)
                            ParametrRow(iconName: "figure.stand.dress.line.vertical.figure", name: "Пол", value: user.wrappedGender, valueType: "") {
                                activeParam = .gender
                            }
                                .frame(minHeight: 60)
                            ParametrRow(iconName: "gearshape.fill", name: "Больше", value: "", valueType: "") {
                                self.toSettings = true
                            }
                                .frame(minHeight: 60)
                            
                        }
                        .padding(15)
                        .sheet(item: $activeParam) { param in
                            switch param {
                            case .height:
                                HeightView(user: user)
                            case .width:
                                WeightView(user: user)
                            case .gender:
                                SexView(user: user)
                            }
                        }
                        .navigationDestination(isPresented: $toSettings) {
                            SettingsView(user: user)
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Достижения")
                                    .blockLabel()
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            
                            VStack(spacing: 15) {
                                Group {
                                    HStack(spacing: 15) {
                                        AchivmentBlock(icon: "star.fill", mainText: "Отжался", descriptionText: "15 раз")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        AchivmentBlock(icon: "star.fill", mainText: "Отжался", descriptionText: "15 раз")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    HStack(spacing: 15) {
                                        AchivmentBlock(icon: "star.fill", mainText: "Отжался", descriptionText: "15 раз")
                                            .frame(maxWidth: .infinity)
                                        NavigationLink(destination: AchivmentView()) {
                                            AchivmentBlock(icon: "arrow.right", mainText: "", descriptionText: "Больше...", grayStyle: true)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                                .padding(.horizontal, 15)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        Color.clear
                            .frame(height: 80)
                    }
                }
            }
        }
        .onAppear {
            accountViewModel.calculateAverageAccuracy()
            accountViewModel.currentStreak()
        }
    }
}
