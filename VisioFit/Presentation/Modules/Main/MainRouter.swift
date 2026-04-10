import SwiftUI

struct MainRouter: View {
    @State private var appScreen: AppScreen = .statistics
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appScreen {
                case .account:
                    AccoutView()
                case .main:
                    EmptyView()
                case .statistics:
                    StatisticsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            NavigationBarView(selectedScreen: $appScreen)
        }
        .background(Color.baseBg)
    }
}

#Preview {
    MainRouter()
}
 
