import SwiftUI

struct AccentDescription: ViewModifier {
    let fontSize: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.accentDescription)
            .font(.system(size: fontSize, weight: weight))
    }
}

extension View {
    func accentDescription(fontSize: CGFloat = 20, weight: Font.Weight = .regular) -> some View {
        modifier(AccentDescription(fontSize: fontSize, weight: weight))
    }
}
