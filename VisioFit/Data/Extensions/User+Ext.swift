import Foundation


extension User {
    private var currentStep: LevelStep {
        let currentXP = Int(self.xp)
        return LevelManager.steps.last { currentXP >= $0.requiredXP } ?? LevelManager.steps[0]
    }
    
    private var nextStep: LevelStep? {
        let currentXP = Int(self.xp)
        return LevelManager.steps.first { $0.requiredXP > currentXP }
    }
    
    var level: Int {
        currentStep.levelNumber
    }
    
    var formattedName: String {
        let userName = self.name
        if var userName {
            let firstChar = userName.removeFirst().uppercased()
            userName = firstChar + userName
            return userName
        }
        return "Аноним"
    }
    
    var sportTitle: String {
        currentStep.title
    }
    
    var formattedXP: String {
        if let next = nextStep {
            return "XP: \(self.xp)/\(next.requiredXP)"
        }
        return "XP: \(self.xp)"
    }
    
    var nextXp: Int64 {
        Int64(nextStep?.requiredXP ?? LevelManager.maxXP)
    }
    
    var xpPercent: String {
        return String(format: "%.2f", (Double(self.xp) / Double(self.nextXp)) * 100)
    }
    
    var wrappedGender: String {
        return self.gender ?? "Мужской"
    }
    
    var totalProgressPercent: Double {
        let maxXP = Double(LevelManager.maxXP)
        guard maxXP > 0 else { return 0 }
        return min((Double(self.xp) / maxXP) * 100, 100)
    }
}
