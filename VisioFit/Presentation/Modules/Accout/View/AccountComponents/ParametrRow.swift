import SwiftUI

struct ParametrRow: View {
    let iconName: String
    let name: String
    let value: String
    let valueType: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                HStack(spacing: 20) {
                    DefaultIcon(iconName: iconName, maxWidth: 40, maxHeight: 40)
                    
                    Text(name)
                        .headText(fontSize: 20, weight: .bold)
                        .lineLimit(1)
                        .layoutPriority(1)
                }
                .padding(.leading, 20)
                Spacer()
                HStack(spacing: 8) {
                    Text(valueType.isEmpty ? value : "\(value) \(valueType)")
                        .accentDescription(fontSize: 14)
                        .lineLimit(1)
                    
                    Image(systemName: "chevron.right")
                        .accentDescription(fontSize: 14)
                }
                .padding(.trailing, 20)
                
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .mainBlock()
        }
    }
}
