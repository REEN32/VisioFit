import SwiftUI

struct RepeatCountLines: View {
    let count: Int
    let target: Int
    
    var body: some View {
        HStack {
            ForEach(0..<target, id:\.self) { item in
                Capsule()
                    .frame(height: 15)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(item < count ? Color.white : Color.borderBlock)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.baseBg.ignoresSafeArea()
        RepeatCountLines(count: 3, target: 12)
    }
}
