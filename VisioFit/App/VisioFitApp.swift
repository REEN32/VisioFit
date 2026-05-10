//
//  VisioFitApp.swift
//  VisioFit
//
//  Created by Герман Василевич on 1.04.26.
//

import SwiftUI
import CoreData

@main
struct VisioFitApp: App {
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coreDataManager)
        }
    }
}

struct RootView: View {
    @State private var isFirstLaunch: Bool = CoreDataManager.shared.isFirstLaunch()
    
    var body: some View {
        if !isFirstLaunch {
            MainRouter()
        } else {
            RegisterCoordinator()
                .environment(\.isFirstLaunch, $isFirstLaunch)
        }
    }
}

struct IsFirstLaunchKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isFirstLaunch: Binding<Bool> {
        get {
            self[IsFirstLaunchKey.self]
        } set {
            self[IsFirstLaunchKey.self] = newValue
        }
    }
}

#Preview {
    RootView()
}
