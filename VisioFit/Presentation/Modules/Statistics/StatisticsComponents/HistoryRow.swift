import SwiftUI

struct HistoryRow: View {
    let date: String
    let desctiptionRepetitions: Int
    let isTimeCounting: Bool
    let time: String
    let percent: Int
    
    init(date: String, desctiptionRepetitions: Int, isTimeCounting: Bool = false, time: String, percent: Int) {
        self.date = date
        self.desctiptionRepetitions = desctiptionRepetitions
        self.isTimeCounting = isTimeCounting
        self.time = time
        self.percent = percent
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(date)
                    .headText(fontSize: 20, weight: .bold)
                Text("\(desctiptionRepetitions) \(isTimeCounting ? "мин" : "повторений") • \(time) мин")
                    .accentDescription(fontSize: 16)
            }
            Spacer()
            VStack {
                Text("\(percent)%")
                    .orangeText()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .mainBlock()
    }
}

#Preview {
    HistoryRow(date: "27 ноя, Пн • 14:00", desctiptionRepetitions: 53, time: "4:32", percent: 84)
}
