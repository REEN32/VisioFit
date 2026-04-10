import SwiftUI

struct BasicChart: View {
    let data: [Int]
    
    private var multiplyIndex: [Double] {
        let maxValue = data.max() ?? 1
        guard maxValue > 0 else { return Array(repeating: 0, count: data.count) }
        return data.map { Double($0) / Double(maxValue) }
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom) {
                ForEach (0..<data.count, id:\.self) { i in
                    VStack {
                        Spacer()
                    Rectangle()
                            .foregroundColor(
                                .accentOrange
                                    .opacity(max(multiplyIndex[i] * 1.5, 0.4))
                            )
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
                        .frame(maxHeight: proxy.size.height * multiplyIndex[i])
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    BasicChart(data: [50, 10, 40, 30, 60, 80, 42])
        .frame(maxWidth: 300, maxHeight: 200)
}
