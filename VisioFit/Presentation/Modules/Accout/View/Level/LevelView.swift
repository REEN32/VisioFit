import SwiftUI

struct LevelView: View {
    private let statusArray: [(String, Int)] = [("Дрыщ", 0), ("Даун", 300), ("Еблан", 600), ("Пидор", 900), ("Хуесос", 1200), ("Очкошник", 1500), ("Слабак", 1800), ("Немощь", 2100), ("Мощь", 2400), ("Сила", 2600), ("Герман", 3000)].reversed()
    
    private let height: CGFloat = 3000
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 20) {
                        VStack {
                            VerticalProgressBar(percent: 52)
                                .frame(width: 50, height: height)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(statusArray, id:\.0) { status, points in
                                HStack(alignment: .lastTextBaseline) {
                                    Text(status)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .headText(fontSize: 26, weight: .bold)
                                    Spacer()
                                    Text("\(points)")
                                        .accentDescription(weight: .bold)
                                }
                                Divider()
                                    .frame(maxWidth: .infinity, maxHeight: 3)
                                    .background(Color.accentDescription)
                                Text("Ур. \(statusArray.count)")
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 15)
                                    .orangeText(fontSize: 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color.accentOrange.opacity(0.3))
                                    )
                                if status != self.statusArray.last?.0 {
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .id("BOTTOM")
                    
                    Color.clear
                        .frame(height: 80)
                }
                .onAppear {
                    DispatchQueue.main.async {
                        proxy.scrollTo("BOTTOM")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("ПРОГРЕСС")
                    .headText()
            }
        }
    }
}

#Preview {
    LevelView()
}
