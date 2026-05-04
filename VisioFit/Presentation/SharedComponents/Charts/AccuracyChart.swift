import SwiftUI

struct AccuracyChart: View {
    let data: [Double]
    let lineWidth: CGFloat
    private var maxYValue: Double
    
    init(data: [Double], lineWidth: CGFloat = 5) {
        self.data = data
        self.lineWidth = lineWidth
        self.maxYValue = data.max() ?? 1
    }

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            let points = calculatePoints(width: width, height: height)
            
            ZStack {
                Path { path in
                    path.addLines(points)
                }
                .stroke(
                    Color.orange,
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round)
                )
            }
        }
        .aspectRatio(3, contentMode: .fit)
    }
    
    private func calculatePoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        guard data.count > 1 else { return [] }
        
        let stepX = width / CGFloat(data.count - 1)
        var points: [CGPoint] = []
        
        for index in 0..<data.count {
            let x = stepX * CGFloat(index)
            
            let fraction = data[index] / maxYValue
            let y = height - (CGFloat(fraction) * height)
            
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
}

#Preview {
    AccuracyChart(data: [50, 10, 40, 30, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100, 84, 42,50, 10, 50, 100])
        .frame(maxWidth: .infinity)
}
