import SwiftUI

struct OrangeText: ViewModifier {
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.accentOrange)
            .font(.system(size: fontSize, weight: .heavy))
    }
}

extension View {
    func orangeText(fontSize: CGFloat = 20) -> some View {
        modifier(OrangeText(fontSize: fontSize))
    }
}
