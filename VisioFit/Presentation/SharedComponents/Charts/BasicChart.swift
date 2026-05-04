import SwiftUI

struct BasicChart: View {
    let data: [Double]
    
    private var multiplyIndex: [Double] {
        let maxValue = data.max() ?? 1
        guard maxValue > 0 else { return Array(repeating: 0, count: data.count) }
        return data.map { Double($0) / Double(maxValue) }
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom) {
                ForEach (0..<data.count, id:\.self) { i in
                    VStack(spacing: 2) {
                        Spacer()
                        Text(data[i].formatted())
                            .accentDescription(fontSize: 13)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Rectangle()
                            .foregroundColor(
                                .accentOrange
                                    .opacity(max(multiplyIndex[i] * 1.3, 0.4))
                            )
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
                        .frame(maxHeight: (proxy.size.height - 30) * multiplyIndex[i])
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(3, contentMode: .fit)
    }
}

#Preview {
    BasicChart(data: [50, 10, 40, 30, 60, 80, 42])
        .frame(maxWidth: 300, maxHeight: 200)
}
