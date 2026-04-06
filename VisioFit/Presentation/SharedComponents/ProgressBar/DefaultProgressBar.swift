import SwiftUI

struct DefaultProgressBar: View {
    var actualValue: Double
    var maxValue: Double
    private var progress: Double {
        guard maxValue > 0 else { return 0 }
        return (actualValue / maxValue)
    }
    
    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(Color.baseBg)
            
            Capsule()
                .fill(Color.accentOrange)
                .frame(width: proxy.size.width * CGFloat(progress))
                .animation(.spring, value: progress)
        }
    }
}
