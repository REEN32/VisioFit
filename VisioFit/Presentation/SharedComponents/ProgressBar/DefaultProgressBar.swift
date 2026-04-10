import SwiftUI

struct DefaultProgressBar: View {
    var actualValue: Double
    var maxValue: Double
    private var progress: Double {
        guard maxValue > 0 else { return 0 }
        guard actualValue / maxValue < 1 else { return 1 }
        return (actualValue / maxValue)
    }
    
    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(Color.baseBg)
            
            Capsule()
                .fill(progress == 1 ? Color.successGreen : Color.accentOrange)
                .frame(width: proxy.size.width * CGFloat(progress))
                .animation(.spring, value: progress)
        }
    }
}
