enum TimePeriod: Identifiable {
    var id: Int { self.hashValue }
    case week
    case month
    case year
    case allTime
}
