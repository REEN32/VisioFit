import SwiftUI

struct ParametrRow: View {
    let iconName: String
    let name: String
    let value: String
    let valueType: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            DefaultIcon(iconName: iconName, maxWidth: 40, maxHeight: 40)
                            VStack(alignment: .leading) {
                                Text(name)
                                    .headText(fontSize: 20, weight: .bold)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text(value + " " + valueType)
                                .accentDescription(fontSize: 14)
                            Image(systemName: "chevron.right")
                                .accentDescription(fontSize: 14)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
            }
            .mainBlock()
        }
    }
}
