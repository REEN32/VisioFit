import SwiftUI

struct ExerciseRow: View {
    let name: String
    let desctiptionRepetitions: String
    let isTimeCounting: Bool
    let descriptionTraining: String
    let percent: String
    
    init(name: String, desctiptionRepetitions: String, isTimeCounting: Bool = false, descriptionTraining: String, percent: String) {
        self.name = name
        self.desctiptionRepetitions = desctiptionRepetitions
        self.isTimeCounting = isTimeCounting
        self.descriptionTraining = descriptionTraining
        self.percent = percent
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .headText(fontSize: 20, weight: .bold)
                Text("\(desctiptionRepetitions) \(isTimeCounting ? "мин" : "повторений") • \(descriptionTraining) сессий")
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

//#Preview {
//    ExerciseRow(name: "Отжимания", desctiptionRepetitions: 543, descriptionTraining: 23, percent: 84) {
//    }
//}
