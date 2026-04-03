import SwiftUI

struct DefaultProgressBar: View {
    var actualValue: Double
    var maxValue: Double
    private var progress: Double {
        actualValue / maxValue
    }
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .background(Color.baseBg)
                .clipShape(Capsule())
            
            Rectangle()
                .background(Color.baseBg)
                .clipShape(Capsule())
        }
    }
}
