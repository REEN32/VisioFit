import Foundation

struct LevelStep {
    let levelNumber: Int
    let title: String
    let requiredXP: Int
}

struct LevelManager {
    static let steps: [LevelStep] = [
        LevelStep(levelNumber: 1, title: "Дрыщ", requiredXP: 0),
        LevelStep(levelNumber: 2, title: "Даун", requiredXP: 300),
        LevelStep(levelNumber: 3, title: "Еблан", requiredXP: 600),
        LevelStep(levelNumber: 4, title: "Пидор", requiredXP: 900),
        LevelStep(levelNumber: 5, title: "Хуесос", requiredXP: 1200),
        LevelStep(levelNumber: 6, title: "Очкошник", requiredXP: 1500),
        LevelStep(levelNumber: 7, title: "Слабак", requiredXP: 1800),
        LevelStep(levelNumber: 8, title: "Немощь", requiredXP: 2100),
        LevelStep(levelNumber: 9, title: "Мощь", requiredXP: 2400),
        LevelStep(levelNumber: 10, title: "Сила", requiredXP: 2700),
        LevelStep(levelNumber: 11, title: "Герман", requiredXP: 3000)
    ]
    
    static var maxXP: Int {
        steps.last?.requiredXP ?? 3000
    }
}
