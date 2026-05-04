import SwiftUI

struct DefaultIcon: View {
    let iconName: String
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(Color.accentOrange)
        }
        .frame(width: maxWidth, height: maxHeight)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.orangeTint)
        )
    }
}
