import Foundation

extension Date {
    var workoutDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, EEE • HH:mm"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    var todayDate: String {
        let formattedDate = self.formatted(
            .dateTime
            .weekday(.wide)
            .day(.defaultDigits)
            .month(.wide)
            .locale(Locale(identifier: "ru_RU"))
        )
        return formattedDate
    }
}
