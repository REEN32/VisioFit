import SwiftUI

struct GreenTintBlock: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.greenTint)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.greenTintBorder, lineWidth: 3)
            )
    }
}

extension View {
    func greenTintBlock() -> some View {
        modifier(GreenTintBlock())
    }
}
