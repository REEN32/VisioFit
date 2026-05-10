import SwiftUI

struct PageSelector: View {
    @State private var selectedPage: Int
    
    init(selectedPage: Int) {
        self.selectedPage = selectedPage
    }
    
    var body: some View {
        HStack(spacing: 5) {
            circle(isSelected: selectedPage == 0)
            circle(isSelected: selectedPage == 1)
            circle(isSelected: selectedPage == 2)
        }
    }
    
    @ViewBuilder
    private func circle(isSelected: Bool) -> some View {
        if isSelected {
            Capsule()
                .overlay(
                    Color.accentOrange
                )
                .clipShape(Capsule())
        } else {
            Circle()
                .overlay(
                    Color.borderBlock
                )
                .clipShape(Circle())
        }
    }
}

//#Preview {
//    PageSelector()
//        .frame(maxWidth: 70, maxHeight: 20)
//}
