import SwiftUI

struct AchivmentView: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.baseBg
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 15) {
                    AchivmentRow(iconName: "star", name: "Test", description: "Description", value: 52, maxValue: 100, exp: 15)
                    AchivmentRow(iconName: "star", name: "Test", description: "Description", value: 9999, maxValue: 1000, exp: 150)
                    AchivmentRow(iconName: "star", name: "Test", description: "Description", value: 1, maxValue: 1, exp: 15000)
                    AchivmentRow(iconName: "star", name: "Test", description: "Description", value: 52, maxValue: 1123, exp: 15)
                }
                .padding(15)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("ДОСТИЖЕНИЯ")
                    .headText()
            }
        }
    }
}

#Preview {
    AchivmentView()
}
