import SwiftUI

struct NavigationBarView: View {
    @State private var selectedTab: Int = 2
    
    var body: some View {
        HStack {
            TabItem(icon: "chart.bar.fill", name: "Статистика", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            TabItem(icon: "house.fill", name: "Главная", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            TabItem(icon: "person.fill", name: "Профиль", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
        .foregroundStyle(Color.secondaryText)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(Color.surfaceBg)
        .clipShape(Capsule())
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack {
        Spacer()
        NavigationBarView()
    }
    .ignoresSafeArea()
}
