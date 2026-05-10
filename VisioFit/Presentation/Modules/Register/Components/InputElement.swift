import SwiftUI

struct InputElement: View {
    let name: String
    let descriptionText: String
    let keyboardType: UIKeyboardType
    let isNumberic: Bool
    let range: ClosedRange<Int>
    
    @Binding var textInput: String
    
    init(name: String, descriptionText: String, keyboardType: UIKeyboardType = .default, isNumberic: Bool = false, range: ClosedRange<Int> = 0...99, textInput: Binding<String>) {
        self.name = name
        self.descriptionText = descriptionText
        self.keyboardType = keyboardType
        self.isNumberic = isNumberic
        self.range = range
        self._textInput = textInput
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .accentDescription(fontSize: 20, weight: .bold)
                .textCase(.uppercase)
            if isNumberic {
                TextField(descriptionText, text: $textInput)
                    .padding(15)
                    .border(Color.borderBlock, width: 1)
                    .keyboardType(keyboardType)
                    .foregroundStyle(.white)
                    .onChange(of: textInput) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        
                        if let value = Int(filtered) {
                            if value > self.range.upperBound {
                                self.textInput = "\(self.range.upperBound)"
                            } else {
                                self.textInput = "\(value)"
                            }
                        } else {
                            self.textInput = ""
                        }
                    }
            } else {
                TextField(descriptionText, text: $textInput)
                    .padding(15)
                    .border(Color.borderBlock, width: 1)
                    .keyboardType(keyboardType)
                    .foregroundStyle(.white)
            }
        }
    }
}
