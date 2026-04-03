import SwiftUI

struct DescriptionStyle: ViewModifier {
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.secondaryText)
            .font(.system(size: fontSize))
    }
}

extension View {
    func descriptionStyle(fontSize: CGFloat = 20) -> some View {
        modifier(DescriptionStyle(fontSize: fontSize))
    }
}
