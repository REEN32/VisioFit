import SwiftUI

struct HeadText: ViewModifier {
    let fontSize: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: weight))
            .foregroundStyle(Color.white)
    }
}

extension View {
    func headText(fontSize: CGFloat = 30, weight: Font.Weight = .heavy) -> some View {
        modifier(HeadText(fontSize: fontSize, weight: weight))
    }
}
