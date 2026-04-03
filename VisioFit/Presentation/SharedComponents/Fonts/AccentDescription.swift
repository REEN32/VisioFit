import SwiftUI

struct AccentDescription: ViewModifier {
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.accentDescription)
            .font(.system(size: fontSize))
    }
}

extension View {
    func accentDescription(fontSize: CGFloat = 20) -> some View {
        modifier(AccentDescription(fontSize: fontSize))
    }
}
