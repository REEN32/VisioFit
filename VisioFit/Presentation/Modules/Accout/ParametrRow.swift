import SwiftUI

struct ParametrRow: View {
    let iconName: String
    let name: String
    let value: String
    let valueType: String
    
    var body: some View {
        Button {
            print("ParametrRow: флешечка")
        } label: {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: iconName)
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundStyle(Color.accentOrange)
                            }
                            .frame(maxWidth: 40, maxHeight: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color.orangeTint)
                            )
                            VStack(alignment: .leading) {
                                Text(name)
                                    .headText(fontSize: 20, weight: .bold)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text(value + " " + valueType)
                                .accentDescription(fontSize: 14)
                            Image(systemName: "chevron.right")
                                .accentDescription(fontSize: 14)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
            }
            .mainBlock()
        }
    }
}

#Preview {
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
}
