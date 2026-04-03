import SwiftUI

struct TabItem: View {
    let icon: String
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(name)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? Color.accentOrange : Color.secondaryText)
        }
    }
}
