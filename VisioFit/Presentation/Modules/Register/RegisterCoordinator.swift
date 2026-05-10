import SwiftUI

struct RegisterCoordinator: View {
    @StateObject private var router: RegisterRouter = RegisterRouter()
    @StateObject private var vm: RegisterViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            Group {
                switch router.startingSrceen {
                case .main:
                    RegisterView()
                case .firstInput:
                    RegisterFirstInputView()
                case .secondInput:
                    RegisterSecondInputView()
                }
            }
            .navigationDestination(for: RegisterScreen.self) { screen in
                switch screen {
                case .main:
                    RegisterView()
                case .firstInput:
                    RegisterFirstInputView()
                case .secondInput:
                    RegisterSecondInputView()
                }
            }
        }
        .environmentObject(router)
        .environmentObject(vm)
    }
}
