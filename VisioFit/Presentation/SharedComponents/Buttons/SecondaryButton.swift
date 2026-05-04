import SwiftUI

struct SecondaryButton: View {
    let label: String
    let fontSize: CGFloat
    let weight: Font.Weight
    let selected: Bool
    let action: () -> Void
    
    init(label: String, fontSize: CGFloat = 20, weight: Font.Weight = .regular, selected: Bool = false, action: @escaping () -> Void) {
        self.label = label
        self.fontSize = fontSize
        self.weight = weight
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .secondaryButtonText(selected: selected, fontSize: fontSize, weight: weight)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Capsule())
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            (selected ? Color.accentOrange.clipShape(Capsule()) : Color.surfaceBg.clipShape(Capsule()))
        )
        .overlay(
            Capsule()
                .stroke(Color.borderBlock, lineWidth: 3)
        )
    }
}

extension View {
    @ViewBuilder
    fileprivate func secondaryButtonText(selected: Bool, fontSize: CGFloat, weight: Font.Weight) -> some View {
        if selected {
            headText(fontSize: fontSize, weight: weight)
        } else {
            accentDescription(fontSize: fontSize,weight: weight)
        }
    }
}

#Preview {
    ZStack {
        Color.baseBg.ignoresSafeArea()
        SecondaryButton(label: "Нед", weight: .bold, selected: true,action: {})
            .frame(maxWidth: 100, maxHeight: 40)
    }
}
