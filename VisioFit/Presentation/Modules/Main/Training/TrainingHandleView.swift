import SwiftUI

struct TrainingHandleView: View {
    @State private var count: Int = 0
    @State private var countString: String = "0"
    
    @Binding var trainingScreen: TrainingScreen
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.baseBg.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .lastTextBaseline) {
                            Text("Приседания")
                                .headText(fontSize: 26)
                            Spacer()
                            Text("3 подход")
                                .headText(fontSize: 18)
                        }
                        HStack(alignment: .lastTextBaseline) {
                            Text(countString)
                                .headText(fontSize: 60)
                            Text("повторений")
                                .headText(fontSize: 22, weight: .medium)
                        }
                        RepeatCountLines(count: count, target: 12)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .background(Color.accentOrange)
                    
                    VStack(alignment: .center, spacing: 30) {
                        Button {
                            count += 1
                            countString = String(count)
                        } label: {
                            Image(systemName: "arrowshape.up.fill")
                                .padding(20)
                                .background(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                )
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                        
                        
                        // Сделать TextField который нельзя выделять
//                        TextField("", text: $countString)
//                            .headText(fontSize: 60)
//                            .multilineTextAlignment(.center)
//                            .keyboardType(.numberPad)
                        Text(countString)
                            .headText(fontSize: 60)
                            
                        Button {
                            if count > 0 {
                                count -= 1
                                countString = String(count)
                            }
                        } label: {
                            Image(systemName: "arrowshape.down.fill")
                                .padding(20)
                                .background(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                )
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    HStack {
                        DefaultIcon(iconName: "info.circle", maxWidth: 40, maxHeight: 40)
                        Text("TEST TEST TEST")
                            .accentDescription(fontSize: 16)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .orangeTintBlock()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    
                    VStack(spacing: 15) {
                        DefaulButton(label: "Закончить подход") {
                            trainingScreen = .rest
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                    .frame(maxHeight: proxy.size.height * 0.12)
                }
                
                .frame(maxWidth: .infinity)
            }
        }
    }
}

//#Preview {
//    TrainingHandleView()
//}
