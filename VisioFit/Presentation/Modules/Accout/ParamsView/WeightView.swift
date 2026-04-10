import SwiftUI

struct WeightView: View {
    @Binding var weight: Double
    
    @Environment(\.dismiss) var dismiss
    
    private var range: [Double] = Array(stride(from: 30, through: 200, by: 0.5))
    
    init(weight: Binding<Double>) {
        self._weight = weight
    }
    
    var body: some View {
        ZStack {
            Color.baseBg
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Выберите свой вес")
                    .headText(weight: .bold)
                HStack {
                    Picker("", selection: $weight) {
                        ForEach(range, id: \.self) {
                            Text("\($0.formatted())")
                                .headText(fontSize: 24, weight: .bold)
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .pickerStyle(.wheel)
                
                DefaulButton(label: "Сохранить") { dismiss() }
                    .frame(maxWidth: 200, maxHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
