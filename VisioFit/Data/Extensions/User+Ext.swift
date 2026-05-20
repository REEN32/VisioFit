import Foundation


extension User {
    var level: Int {
        var level: Int = 0
        var acctualXP = self.xp
        while acctualXP > 0 {
            level += 1
            acctualXP -= 300
        }
        return level
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
        switch self.xp {
        case 0..<300:
            return "Новичок"
        case 300..<600:
            return "Средний"
        case 600..<900:
            return "Продвинутый"
        default:
            return "Эксперт"
        }
    }
    
    var formattedXP: String {
        let points = [300, 600, 900, 1200, 1500, 1800, 2100, 2400, 2700, 3000]
        
        for p in points {
            if self.xp >= p {
                continue
            } else {
                return "XP: \(self.xp)/\(p)"
            }
        }
        return "XP: \(self.xp)"
    }
    
    var nextXp: Int64 {
        let points = [300, 600, 900, 1200, 1500, 1800, 2100, 2400, 2700, 3000]
        
        for p in points {
            if self.xp >= p {
                continue
            } else {
                return Int64(p)
            }
        }
        return self.xp
    }
    
    var xpPercent: String {
        return String(format: "%.2f", (Double(self.xp) / Double(self.nextXp)) * 100)
    }
    
    var wrappedGender: String {
        return self.gender ?? "Мужской"
    }
}
