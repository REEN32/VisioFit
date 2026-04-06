import SwiftUI

struct BlockLabel: ViewModifier {
    let fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.accentDescription)
            .font(.system(size: fontSize, weight: .bold))
            .textCase(.uppercase)
    }
}

extension View {
    func blockLabel(fontSize: CGFloat = 20) -> some View {
        modifier(BlockLabel(fontSize: fontSize))
    }
}
