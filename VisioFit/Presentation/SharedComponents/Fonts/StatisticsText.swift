import SwiftUI

struct StatisticsText: ViewModifier {
    let isPositive: Bool
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isPositive ? Color.successGreen : Color.badRed)
            .font(Font.system(size: fontSize, weight: .bold))
    }
}

extension View {
    func statisticsText(isPositive: Bool, fontSize: CGFloat = 16) -> some View {
        modifier(StatisticsText(isPositive: isPositive, fontSize: fontSize))
    }
}
