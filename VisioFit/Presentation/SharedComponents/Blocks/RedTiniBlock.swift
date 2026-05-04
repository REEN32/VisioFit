import SwiftUI

struct RedTintBlock: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.redTint)
            .clipShape(.rect(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.redTintBorder, lineWidth: 3)
            )
    }
}

extension View {
    func redTintBlock() -> some View {
        modifier(RedTintBlock())
    }
}
