import SwiftUI

struct LevelView: View {
    private let reversedSteps = LevelManager.steps.reversed()
    
    @ObservedObject var user: User
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 20) {
                        VStack {
                            VerticalProgressBar(percent: user.totalProgressPercent)
                                .frame(width: 50, height: 3000)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(reversedSteps, id:\.levelNumber) { step in
                                HStack(alignment: .lastTextBaseline) {
                                    Text(step.title)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .headText(fontSize: 26, weight: .bold)
                                    Spacer()
                                    Text("\(step.requiredXP)")
                                        .accentDescription(weight: .bold)
                                }
                                Divider()
                                    .frame(maxWidth: .infinity, maxHeight: 3)
                                    .background(Color.accentDescription)
                                Text("Ур. \(step.levelNumber)")
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 15)
                                    .orangeText(fontSize: 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color.accentOrange.opacity(0.3))
                                    )
                                if step.levelNumber != self.reversedSteps.last?.levelNumber {
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
