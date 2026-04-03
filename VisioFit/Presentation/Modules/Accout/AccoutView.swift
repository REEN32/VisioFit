import SwiftUI

struct AccoutView: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    AccoutIcon()
                        .padding(20)
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Василевич Г.")
                                .headText()
                            HStack {
                                Text("Ур. 8")
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 15)
                                    .foregroundStyle(Color.accentOrange)
                                    .font(.system(size: 16, weight: .bold))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color.accentOrange.opacity(0.3))
                                    )
                                Text("Атлет")
                                    .accentDescription(fontSize: 20)
                            }
                        }
                        VStack(spacing: 4) {
                            HStack {
                                Text("XP: 3 240/4 000")
                                    .accentDescription(fontSize: 15)
                                Spacer()
                                Text("67%")
                                    .orangeText(fontSize: 15)
                            }
                            DefaultProgressBar(actualValue: 0, maxValue: 100)
                                .frame(maxWidth: .infinity, maxHeight: 14)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.surfaceBg)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AccoutView()
}
