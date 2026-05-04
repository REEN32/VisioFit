import SwiftUI

struct AccuracyText: ViewModifier {
    let value: Double
    let fontSize: CGFloat
    
    private var color: Color {
        switch value {
        case 0..<60:
            return Color.badRed
        case 60..<85:
            return Color.warmOrange
        case 85...100:
            return Color.successGreen
        default:
            return Color.white
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .font(Font.system(size: fontSize, weight: .bold))
    }
}

extension View {
    func accuracyText(value: Double, fontSize: CGFloat = 20) -> some View {
        modifier(AccuracyText(value: value, fontSize: fontSize))
    }
}
