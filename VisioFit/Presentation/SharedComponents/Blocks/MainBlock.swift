import SwiftUI

struct MainBlock: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.surfaceBg)
            .clipShape(.rect(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.borderBlock, lineWidth: 3)
            )
    }
}

extension View {
    func mainBlock() -> some View {
        modifier(MainBlock())
    }
}
