import SwiftUI

struct MainRouter: View {
    @State private var appScreen: AppScreen = .main
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appScreen {
                case .account:
                    AccoutView()
                case .main:
                    MainView()
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
 
