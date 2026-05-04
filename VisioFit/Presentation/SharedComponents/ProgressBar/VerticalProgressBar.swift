import SwiftUI

struct VerticalProgressBar: View {
    var percent: Double
    
    init(actualValue: Double, maxValue: Double) {
        let progress = actualValue / maxValue
        self.percent = min(max(0, progress), 1)
    }
    
    init(percent: Double) {
        let progress = min(max(0, percent), 100)
        self.percent = progress / 100
    }
    
    var body: some View {
        GeometryReader { proxy in
            
            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.surfaceBg)
                
                Capsule()
                    .fill(percent == 1 ? Color.successGreen : Color.accentOrange)
                    .frame(height: proxy.size.height * CGFloat(percent))
                    .animation(.spring, value: percent)
            }
        }
    }
}
