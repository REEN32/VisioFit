import SwiftUI

struct CircleProgrssBar: View {
    let value: Double
    let maxValue: Double
    let lineWidth: CGFloat
    let fontSize: CGFloat
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    private var progress: Double {
        guard maxValue > 0 else { return 0 }
        guard value / maxValue < 1 else { return 1 }
        return value / maxValue
    }
    
    
    var body: some View {
        VStack(spacing: -5) {
            Text(String(value.formatted()))
                .frame(maxWidth: maxWidth / 2)
                .accentDescription(fontSize: fontSize, weight: .bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("ккал")
                .accentDescription(fontSize: fontSize / 1.4)
        }
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .background(
            Circle()
                .trim(from: 0.3, to: 1)
                .stroke(
                    Color.baseBg,
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 35))
        )
        .overlay(
            Circle()
                .trim(from: 0.3, to: 0.3 + (0.7 * progress))
                .stroke(
                    Color.accentOrange,
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 35))
        )
        .padding(.top, 10)
    }
}

#Preview {
    CircleProgrssBar(value: 675214, maxValue: 100, lineWidth: 15, fontSize: 30, maxWidth: 100, maxHeight: 100)
}
