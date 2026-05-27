import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    @Published var isPaid: Bool = false
    
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var gender: String = ""
    
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var calories: String = ""
    
    private let coreData = CoreDataManager.shared
    
    func registerUser() {
        coreData.addEntity(User.self) { user in
            user.name = self.name
            user.age = Int16(self.age) ?? 0
            user.gender = self.gender
            user.height = Int16(self.height) ?? 0
            user.isPaid = self.isPaid
            user.weight = Double(self.weight) ?? 0.0
            user.xp = 0
            user.streak = 0
            user.maxStreak = 0
            user.kkalGoal = Int16(self.calories) ?? 0
        }
    }
}
