import SwiftUI

struct MainRouter: View {
    @State private var appScreen: AppScreen = .account
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appScreen {
                case .account:
                    AccoutView()
                case .main:
                    VStack {
                        
                    }
                case .satats:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            NavigationBarView()
        }
        .background(Color.baseBg)
    }
}

#Preview {
    MainRouter()
}
