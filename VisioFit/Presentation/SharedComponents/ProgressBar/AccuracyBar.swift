import SwiftUI

struct AccuracyBar: View {
    var percent: Double
    private var color: Color {
        switch percent {
        case 0.0..<0.6:
            return Color.badRed
        case 0.6..<0.85:
            return Color.warmOrange
        case 0.85...1:
            return Color.successGreen
        default:
            return Color.white
        }
    }
    
    init(percent: Double) {
        let progress = min(max(0, percent), 100)
        self.percent = progress / 100
    }
    
    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(Color.baseBg)
            
            Capsule()
                .fill(color)
                .frame(width: proxy.size.width * CGFloat(percent))
                .animation(.spring, value: percent)
        }
    }
}
