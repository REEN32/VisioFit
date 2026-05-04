import SwiftUI

struct TrainigRow: View {
    let name: String
    let image: String
    let desctiptionCount: Double
    let isTime: Bool
    let percent: Double
    
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            DefaultIcon(iconName: image, maxWidth: 60, maxHeight: 60)
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .headText(fontSize: 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                HStack {
                    DefaultProgressBar(percent: percent)
                        .frame(height: 9)
                    Text(percent >= 100 ? "100%" : "\(percent.formatted())%")
                        .accentDescription(fontSize: 16, weight: .bold)
                }
                Text(percent >= 100 ? "Выполнено" : ("\(desctiptionCount.formatted())" + (isTime ? " мин" : " подхода")))
                    .accentDescription(fontSize: 16)
            }
            SecondaryButton(label: "СТАРТ", fontSize: 18, weight: .bold, selected: true) {
                action()
            }
            .frame(maxWidth: 100, maxHeight: 45)
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .mainBlock()
    }
}

#Preview {
    TrainigRow(name: "Пресс", image: "square", desctiptionCount: 4, isTime: false, percent: 700) {
        
    }
}
