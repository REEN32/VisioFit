import SwiftUI

struct DefaulButton: View {
    let label: String
    let fontSize: CGFloat
    let weight: Font.Weight
    let action: () -> Void
    
    init(label: String, fontSize: CGFloat = 26, weight: Font.Weight = .bold, action: @escaping () -> Void) {
        self.label = label
        self.fontSize = fontSize
        self.weight = weight
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .headText(fontSize: fontSize, weight: weight)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white)
        }
    }
}

#Preview {
    ZStack {
        Color.baseBg.ignoresSafeArea()
        DefaulButton(label: "Сохранить", action: {})
            .frame(maxWidth: 200, maxHeight: 90)
    }
}
