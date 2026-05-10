import SwiftUI

struct AccoutIcon: View {
    
    var body: some View {
        VStack {
            Text("ВГ")
                .font(.system(size: 36, weight: .heavy))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: 100, maxHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.accentOrange)
        )
    }
}
