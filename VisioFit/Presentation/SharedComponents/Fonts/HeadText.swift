import SwiftUI

struct HeadText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .heavy))
            .foregroundStyle(Color.white)
    }
}

extension View {
    func headText() -> some View {
        modifier(HeadText())
    }
}
