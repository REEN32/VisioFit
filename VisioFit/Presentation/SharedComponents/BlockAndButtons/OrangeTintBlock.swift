import SwiftUI

struct OrangeTintBlock: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.orangeTint)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orangeTintBorder, lineWidth: 3)
            )
    }
}

extension View {
    func orangeTintBlock() -> some View {
        modifier(OrangeTintBlock())
    }
}
