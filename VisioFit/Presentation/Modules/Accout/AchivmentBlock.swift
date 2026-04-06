import SwiftUI

struct AchivmentBlock: View {
    let icon: String
    let mainText: String
    let descriptionText: String
    let grayStyle: Bool
    
    init(icon: String, mainText: String, descriptionText: String, grayStyle: Bool = false) {
        self.icon = icon
        self.mainText = mainText
        self.descriptionText = descriptionText
        self.grayStyle = grayStyle
    }
    
    var body: some View {
        Button {
            print("AchivmentBlock: флешечка")
        } label: {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .heavy))
                    .achivmentIconStyle(isGray: grayStyle)
                    .frame(minWidth: 70, minHeight: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.orangeTint)
                    )
                    .padding(.bottom, 10)
                Text(mainText)
                    .headText(fontSize: 14, weight: .bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                Text(descriptionText)
                    .accentDescription(fontSize: 12)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .blockStyle(isGray: grayStyle)
        }
    }
}

extension View {
    @ViewBuilder
    func blockStyle(isGray: Bool) -> some View {
        if isGray {
            mainBlock()
        } else {
            orangeTintBlock()
        }
    }
    
    @ViewBuilder
    func achivmentIconStyle(isGray: Bool) -> some View {
        if isGray {
            foregroundStyle(Color.surfaceBg)
        } else {
            foregroundStyle(Color.accentOrange)
        }
    }
}
