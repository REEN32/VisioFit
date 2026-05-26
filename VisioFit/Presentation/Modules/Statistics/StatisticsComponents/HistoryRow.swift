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
                Text("\(desctiptionRepetitions) \(isTimeCounting ? "cек" : "повторений") • \(time) мин")
                    .accentDescription(fontSize: 16)
            }
            Spacer()
            VStack {
                if percent < 0 {
                    Text("–%")
                        .orangeText()
                } else {
                    Text("\(percent)%")
                        .orangeText()
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .mainBlock()
    }
}
