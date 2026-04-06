import SwiftUI

struct AccoutView: View {
    
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
                                Text("Василевич Г.")
                                    .headText()
                                HStack {
                                    Text("Ур. 8")
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 15)
                                        .orangeText(fontSize: 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .foregroundStyle(Color.accentOrange.opacity(0.3))
                                        )
                                    Text("Атлет")
                                        .accentDescription(fontSize: 20)
                                }
                            }
                            VStack(spacing: 4) {
                                HStack {
                                    Text("XP: 3 240/4 000")
                                        .accentDescription(fontSize: 15)
                                    Spacer()
                                    Text("67%")
                                        .orangeText(fontSize: 15)
                                }
                                DefaultProgressBar(actualValue: 52, maxValue: 100)
                                    .frame(maxWidth: .infinity, maxHeight: 12)
                            }
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
                                        Text("38")
                                            .orangeText(fontSize: 32)
                                        Text("Тренировок")
                                            .accentDescription(fontSize: 14)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack {
                                        Text("87%")
                                            .orangeText(fontSize: 32)
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
                                            .foregroundStyle(Color.accentOrange)
                                    }
                                    .frame(maxWidth: 70, maxHeight: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color.orangeTint)
                                    )
                                    VStack {
                                        Text("14")
                                            .orangeText(fontSize: 32)
                                        Text("Дней подряд")
                                            .accentDescription(fontSize: 14)
                                    }
                                    VStack {
                                        Text("52")
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
                            ParametrRow(iconName: "arrow.up", name: "Рост", value: "172", valueType: "см")
                                .frame(minHeight: 60)
                            ParametrRow(iconName: "scalemass.fill", name: "Вес", value: "70", valueType: "кг")
                                .frame(minHeight: 60)
                            ParametrRow(iconName: "figure.stand.dress.line.vertical.figure", name: "Пол", value: "Мужской", valueType: "")
                                .frame(minHeight: 60)
                            
                        }
                        .padding(15)
                        
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
                                        AchivmentBlock(icon: "star.fill", mainText: "Соснул хуйца", descriptionText: "15 раз")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        AchivmentBlock(icon: "star.fill", mainText: "Соснул хуйца", descriptionText: "15 раз")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    HStack(spacing: 15) {
                                        AchivmentBlock(icon: "star.fill", mainText: "Соснул хуйца", descriptionText: "15 раз")
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
    }
}

#Preview {
    AccoutView()
}
