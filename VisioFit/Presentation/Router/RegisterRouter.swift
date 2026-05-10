import SwiftUI
import Combine

class RegisterRouter: ObservableObject {
    @Published var navPath = NavigationPath()
    
    var startingSrceen: RegisterScreen = .main
    
    func push(to route: RegisterScreen) {
        navPath.append(route)
    }
    
    func pop() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }
    
    func popToRoot() {
        navPath.removeLast(navPath.count)
    }
}
