import SwiftUI

struct AchivmentRow: View {
    let iconName: String
    let name: String
    let description: String
    let value: Double
    let maxValue: Double
    let exp: Int
    
    private var percent: Double {
        guard maxValue > 0 else { return 0 }
        guard value / maxValue < 1 else { return 100 }
        return value * 100 / maxValue
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(name)
                                .headText(fontSize: 20, weight: .bold)
                            Spacer()
                            Text("\(exp) XP")
                                .accentDescription(fontSize: 14)
                        }
                        Text(description)
                            .accentDescription(fontSize: 14)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(value.formatted()) / \(maxValue.formatted())")
                            Spacer()
                            Text("\(percent.formatted(.number.precision(.fractionLength(0...2))))%")
                        }
                        .accentDescription(fontSize: 14)
                        DefaultProgressBar(actualValue: value, maxValue: maxValue)
                            .frame(maxWidth: .infinity, maxHeight: 10)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
        }
        .achivmentViewBg(complited: percent == 100)
    }
}

extension View {
    @ViewBuilder
    fileprivate func achivmentViewBg(complited: Bool) -> some View {
        if complited {
            greenTintBlock()
        } else {
            orangeTintBlock()
        }
    }
}

#Preview {
    ZStack {
        Color.baseBg.edgesIgnoringSafeArea(.all)
        
        AchivmentRow(iconName: "star", name: "Test", description: "Description", value: 99, maxValue: 100, exp: 15)
            .padding(15)
    }
}
